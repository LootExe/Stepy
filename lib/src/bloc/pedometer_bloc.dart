import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../extensions.dart';
import '../model/step_data.dart';
import '../repository/history_repository.dart';
import '../repository/pedometer_repository.dart';

part 'pedometer_state.dart';
part 'pedometer_event.dart';

class PedometerBloc extends Bloc<PedometerEvent, PedometerState> {
  PedometerBloc({
    required PedometerRepository pedometer,
    required HistoryRepository history,
  })  : _pedometer = pedometer,
        _history = history,
        super(PedometerInitial(
          pedometer.stepsCurrentDay,
          history.dailyRecord,
          history.dailyAverage,
          _reverseHistory(history.dailyHistory),
        )) {
    on<PedometerStarted>(_onStarted);
    on<PedometerStopped>(_onStopped);
    on<PedometerFailed>(_onFailed);
    on<PedometerNewDataReceived>(_onDataReceived);
  }

  final PedometerRepository _pedometer;
  final HistoryRepository _history;
  StreamSubscription<int>? _stream;

  /// Start the Pedometer UI Stream
  Future<void> _onStarted(
      PedometerEvent event, Emitter<PedometerState> emit) async {
    _stream?.cancel();
    await _pedometer.registerSensor();

    // Add one entry on first app start
    if (_history.dailyHistory.isEmpty) {
      await _history.add(StepData());
    }

    _stream = _pedometer.stepCountStream.listen(
      (dailySteps) async {
        final lastEntry = _history.dailyHistory.last;

        if (lastEntry.timestamp.isToday) {
          lastEntry.steps = dailySteps;
          await lastEntry.save();
        } else {
          await _history.add(StepData()
            ..steps = dailySteps
            ..timestamp = DateTime.now());
        }

        add(PedometerNewDataReceived(dailySteps));
      },
      onError: (error) => add(PedometerFailed()),
      cancelOnError: true,
    );
  }

  /// Stop Pedometer UI Stream
  Future<void> _onStopped(
      PedometerEvent event, Emitter<PedometerState> emit) async {
    _stream?.cancel();
    await _pedometer.unregisterSensor();

    emit(PedometerStopSuccess(
      _pedometer.stepsCurrentDay,
      _history.dailyRecord,
      _history.dailyAverage,
      _reverseHistory(_history.dailyHistory),
    ));
  }

  /// New daily step count received
  Future<void> _onDataReceived(
      PedometerNewDataReceived event, Emitter<PedometerState> emit) async {
    emit(PedometerNewData(
      event.steps,
      _history.dailyRecord,
      _history.dailyAverage,
      _reverseHistory(_history.dailyHistory),
    ));
  }

  /// Any kind of sensor error
  Future<void> _onFailed(
      PedometerEvent event, Emitter<PedometerState> emit) async {
    emit(const PedometerStartFailure('Sensor error', 0, 0, 0, []));
  }

  static List<StepData> _reverseHistory(List<StepData> entries) {
    final List<StepData> list = [];

    if (entries.length <= 1) {
      return [];
    }

    for (int i = entries.length - 2; i >= 0; i--) {
      list.add(entries[i]);
    }

    return list;
  }

  static Future<bool> get isPermissionGranted async =>
      await Permission.activityRecognition.isGranted;

  static Future<bool> requestPermission() async =>
      await Permission.activityRecognition.request().isGranted;
}
