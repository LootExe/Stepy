part of 'pedometer_bloc.dart';

abstract class PedometerEvent {
  const PedometerEvent();
}

class PedometerStarted extends PedometerEvent {}

class PedometerStopped extends PedometerEvent {}

class PedometerNewDataReceived extends PedometerEvent {
  const PedometerNewDataReceived(this.steps);

  final int steps;
}

class PedometerFailed extends PedometerEvent {}
