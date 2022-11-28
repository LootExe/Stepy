part of 'background_bloc.dart';

abstract class BackgroundState {
  const BackgroundState(this.isRunning);

  final bool isRunning;
}

class BackgroundInitial extends BackgroundState {
  const BackgroundInitial(super.isRunning);
}

class BackgroundStartSuccess extends BackgroundState {
  const BackgroundStartSuccess(super.isRunning);
}

class BackgroundStopSuccess extends BackgroundState {
  const BackgroundStopSuccess(super.isRunning);
}
