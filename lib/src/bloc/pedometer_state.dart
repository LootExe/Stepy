part of 'pedometer_bloc.dart';

abstract class PedometerState {
  const PedometerState(
    this.stepsDaily,
    this.stepsRecord,
    this.stepsAverage,
    this.stepsHistory,
  );

  final int stepsDaily;
  final int stepsRecord;
  final int stepsAverage;
  final List<StepData> stepsHistory;
}

class PedometerInitial extends PedometerState {
  const PedometerInitial(
    super.stepsDaily,
    super.stepsRecord,
    super.stepsAverage,
    super.stepsHistory,
  );
}

class PedometerStartFailure extends PedometerState {
  const PedometerStartFailure(
    this.error,
    super.stepsDaily,
    super.stepsRecord,
    super.stepsAverage,
    super.stepsHistory,
  );

  final String error;
}

class PedometerStopSuccess extends PedometerState {
  const PedometerStopSuccess(
    super.stepsDaily,
    super.stepsRecord,
    super.stepsAverage,
    super.stepsHistory,
  );
}

class PedometerNewData extends PedometerState {
  const PedometerNewData(
    super.stepsDaily,
    super.stepsRecord,
    super.stepsAverage,
    super.stepsHistory,
  );
}
