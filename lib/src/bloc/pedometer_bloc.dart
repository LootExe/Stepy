import 'dart:async';

import 'package:bloc/bloc.dart';

import '../repository/pedometer_repository.dart';

part 'pedometer_state.dart';
part 'pedometer_event.dart';

class PedometerBloc extends Bloc<PedometerEvent, PedometerState> {
  PedometerBloc({required PedometerRepository repository})
      : _repository = repository,
        super(PedometerInitial()) {
    on<PedometerStarted>(_onStarted);
    on<PedometerStopped>(_onStopped);
    on<PedometerNewDataReceived>(_onDataReceived);
    on<PedometerFailed>(_onFailed);

    add(PedometerStarted());
  }

  final PedometerRepository _repository;

  /// Start the Pedometer UI Stream
  Future<void> _onStarted(
      PedometerEvent event, Emitter<PedometerState> emit) async {
    await _repository.listen(
      onData: (steps) => add(PedometerNewDataReceived(steps)),
      onError: (error) => add(PedometerFailed()),
    );
  }

  // TODO: OnAppPause == true : _onStopped;

  /// Stop Pedometer UI Stream
  Future<void> _onStopped(
      PedometerEvent event, Emitter<PedometerState> emit) async {
    await _repository.cancel();
    await _repository.writeData();

    emit(PedometerStopSuccess());
  }

  Future<void> _onDataReceived(
      PedometerNewDataReceived event, Emitter<PedometerState> emit) async {
    emit(PedometerNewData(event.steps));
  }

  Future<void> _onFailed(
      PedometerEvent event, Emitter<PedometerState> emit) async {
    emit(const PedometerStartFailure('Sensor error'));
  }
}
