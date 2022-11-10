part of 'background_bloc.dart';

abstract class BackgroundState {
  const BackgroundState();
}

class BackgroundInitial extends BackgroundState {}

class BackgroundStartSuccess extends BackgroundState {}

class BackgroundStopSuccess extends BackgroundState {}
