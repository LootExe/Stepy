part of 'pedometer_bloc.dart';

abstract class PedometerState {
  const PedometerState();
}

class PedometerInitial extends PedometerState {}

class PedometerStartFailure extends PedometerState {
  const PedometerStartFailure(this.error);

  final String error;
}

class PedometerStopSuccess extends PedometerState {}

class PedometerNewData extends PedometerState {
  const PedometerNewData(this.steps);

  final int steps;
}
