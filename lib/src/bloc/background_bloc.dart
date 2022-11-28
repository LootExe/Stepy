import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:bloc/bloc.dart';
import 'package:foreground/foreground.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

  static const _alarmId = 19871010;
  static const _alarmTime = Duration(minutes: 15);

  Future<void> _onServiceStarted(
      BackgroundEvent event, Emitter<BackgroundState> emit) async {
    await AndroidAlarmManager.periodic(
      _alarmTime,
      _alarmId,
      _onAlarm,
      wakeup: true,
      allowWhileIdle: true,
      rescheduleOnReboot: true,
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
      ),
    );

    emit(const BackgroundStartSuccess(true));
  }

  Future<void> _onServiceStopped(
      BackgroundEvent event, Emitter<BackgroundState> emit) async {
    // Cancel Alarm Manager
    await AndroidAlarmManager.cancel(_alarmId);

    // Stop Foreground Service
    await Foreground.stopService();

    emit(const BackgroundStopSuccess(false));
  }

  /// Initialize the Alarm Manager
  static Future<bool> initializeAlarmManager() async {
    return await AndroidAlarmManager.initialize();
  }

  /// Check if the Foreground service is running
  static Future<bool> get isServiceRunning async => await Foreground.isRunning;

  /// Alarm Manager Callback function
  @pragma('vm:entry-point')
  static Future<void> _onAlarm() async {
    // Initialize Hive
    await _initializeHive();

    final logger = LoggerRepository(
      database: HiveDatabase(
        boxName: LogData.boxName,
      ),
    );

    await logger.initialize();

    // Can't use sensor if foreground service is not running
    if (await Foreground.isRunning == false) {
      logger.add(LogData()
        ..message = 'onAlarm() : Foreground not running'
        ..timestamp = DateTime.now());
      return;
    }

    // Prevent callback from being called multiple times in short periods
    if (await _isEnoughTimeElapsed() == false) {
      logger.add(LogData()
        ..message = 'onAlarm() : Called twice'
        ..timestamp = DateTime.now());
      return;
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
    final result = await pedometer.fetch();

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
      ..message = 'Fetch = $result / Steps = ${history.dailyHistory.last.steps}'
      ..timestamp = DateTime.now());

    await history.close();
    await logger.close();
  }

  static Future<bool> _isEnoughTimeElapsed() async {
    const key = 'onAlarm';
    final storage = PreferencesStorage<DateTime>();
    final lastCall = await storage.read(key);

    await storage.write(key, DateTime.now());

    return lastCall == null ||
        lastCall.difference(DateTime.now()).inSeconds > 10;
  }

  static Future<void> _initializeHive() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(StepDataAdapter().typeId)) {
      Hive.registerAdapter(StepDataAdapter());
    }

    if (!Hive.isAdapterRegistered(LogDataAdapter().typeId)) {
      Hive.registerAdapter(LogDataAdapter());
    }
  }
}
