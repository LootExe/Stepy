import 'package:bloc/bloc.dart';
import 'package:foreground/foreground.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pedometer/pedometer.dart';
import 'package:workmanager/workmanager.dart';

import '../extensions.dart';

import '../model/log_data.dart';
import '../model/step_data.dart';

import '../provider/hive_database.dart';
import '../provider/pedometer_sensor.dart';
import '../provider/preferences_storage.dart';

import '../repository/history_repository.dart';
import '../repository/logger_repository.dart';
import '../repository/pedometer_repository.dart';

part 'background_state.dart';
part 'background_event.dart';

class BackgroundBloc extends Bloc<BackgroundEvent, BackgroundState> {
  BackgroundBloc({required bool isRunning})
      : super(BackgroundInitial(isRunning)) {
    on<BackgroundServiceStarted>(_onServiceStarted);
    on<BackgroundServiceStopped>(_onServiceStopped);
  }

  static const _workmanagerId = 'stepy.workmanager.task';
  static const _workmanagerTime = Duration(minutes: 15);

  Future<void> _onServiceStarted(
      BackgroundEvent event, Emitter<BackgroundState> emit) async {
    await Workmanager().initialize(_workmanagerCallback);

    await Workmanager().registerPeriodicTask(
      _workmanagerId,
      'periodic',
      frequency: _workmanagerTime,
    );

    // Start Foreground Service
    await Foreground.startService(
      configuration: const ForegroundConfiguration(
        notification: NotificationConfiguration(
          channelConfiguration: ChannelConfiguration(
            id: 'stepy_foreground_service',
            name: 'Step counting service',
            description: 'Service for keeping the step sensor alive',
            importance: Importance.low,
          ),
          title: '',
          text: 'Steps are being counted ...',
          visibility: NotificationVisibility.secret,
        ),
        runOnBoot: true,
        callback: _foregroundCallback,
      ),
    );

    emit(const BackgroundStartSuccess(true));
  }

  Future<void> _onServiceStopped(
      BackgroundEvent event, Emitter<BackgroundState> emit) async {
    // Cancel Alarm Manager
    await Workmanager().cancelByUniqueName(_workmanagerId);

    // Stop Foreground Service
    await Foreground.stopService();

    emit(const BackgroundStopSuccess(false));
  }

  /// Check if the Foreground service is running
  static Future<bool> get isServiceRunning async => await Foreground.isRunning;
}

/// Alarm Manager Callback function
@pragma('vm:entry-point')
Future<void> _workmanagerCallback() async {
  Workmanager().executeTask((task, inputData) async {
    // Initialize Hive
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(StepDataAdapter().typeId)) {
      Hive.registerAdapter(StepDataAdapter());
    }

    if (!Hive.isAdapterRegistered(LogDataAdapter().typeId)) {
      Hive.registerAdapter(LogDataAdapter());
    }

    final logger = LoggerRepository(
      database: HiveDatabase(
        boxName: LogData.boxName,
      ),
    );

    await logger.initialize();

    // Can't use sensor if foreground service is not running
    if (await Foreground.isRunning == false) {
      logger.add(LogData()
        ..message = 'Workmanager() : Foreground not running'
        ..timestamp = DateTime.now());
      return true;
    }

    final pedometer = PedometerRepository(
      storage: PreferencesStorage(),
      sensor: PedometerSensor(),
    );
    final history = HistoryRepository(
      database: HiveDatabase(
        boxName: StepData.boxName,
      ),
    );

    await pedometer.initialize();
    await history.initialize();

    await pedometer.registerSensor();
    await pedometer.fetch();

    // Update history repository
    final lastEntry = history.dailyHistory.last;

    if (lastEntry.timestamp.isToday) {
      lastEntry.steps = pedometer.stepsCurrentDay;
      await lastEntry.save();
    } else {
      await history.add(StepData()
        ..steps = pedometer.stepsCurrentDay
        ..timestamp = DateTime.now());
    }

    logger.add(LogData()
      ..message = 'Steps = ${history.dailyHistory.last.steps}'
      ..timestamp = DateTime.now());

    await pedometer.unregisterSensor();
    await history.close();
    await logger.close();

    return true;
  });
}

@pragma('vm:entry-point')
void _foregroundCallback() {
  Foreground.setTaskHandler(
    onStarted: () async {
      await Pedometer.registerSensor(
        configuration: const SensorConfiguration(
          samplingRate: SamplingRate.ui,
          batchingInterval: Duration(
            minutes: 5,
          ),
        ),
      );
    },
    onStopped: () async {
      await Pedometer.unregisterSensor();
    },
  );
}
