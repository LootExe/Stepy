import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:bloc/bloc.dart';
import 'package:foreground/foreground.dart';

import '../debug_utils.dart';
import '../repository/pedometer_repository.dart';

part 'background_state.dart';
part 'background_event.dart';

class BackgroundBloc extends Bloc<BackgroundEvent, BackgroundState> {
  BackgroundBloc() : super(BackgroundInitial()) {
    on<BackgroundServiceStarted>(_onServiceStarted);
    on<BackgroundServiceStopped>(_onServiceStopped);

    IsolateNameServer.registerPortWithName(
        ReceivePort().sendPort, _alarmIsolate);
  }

  static const _alarmId = 19871010;
  static const _alarmIsolate = 'alarmCallbackIsolate';

  Future<void> _onServiceStarted(
      BackgroundEvent event, Emitter<BackgroundState> emit) async {
    await AndroidAlarmManager.periodic(
      const Duration(minutes: 15),
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

    emit(BackgroundStartSuccess());
  }

  Future<void> _onServiceStopped(
      BackgroundEvent event, Emitter<BackgroundState> emit) async {
    // Cancel Alarm Manager
    await AndroidAlarmManager.cancel(_alarmId);

    // Stop Foreground Service
    await Foreground.stopService();

    emit(BackgroundStopSuccess());
  }

  /// Alarm Manager Callback function
  @pragma('vm:entry-point')
  static Future<void> _onAlarm() async {
    // No need to run this method if app is currently active
    if (IsolateNameServer.lookupPortByName(_alarmIsolate) != null) {
      printDebug('onAlarm(): App is active.');
      return;
    }

    // Can't use sensor if foreground service is not running
    if (await Foreground.isRunning == false) {
      printDebug('onAlarm(): Foreground service not running.');
      return;
    }

    // Create new repository instance
    final repository = PedometerRepository();

    // Get latest pedometer readings
    await repository.readData();
    final newSteps = await repository.newSteps;
    final timestamp = DateTime.now();

    // Save newest readings
    await repository.writeData();

    // TODO: Add steps to hourly database
    /// Pseudo Code
    /// database.add(DateTime.now().hour, stepsHourly);
  }
}
