part of 'background_bloc.dart';

abstract class BackgroundEvent {}

class BackgroundServiceStarted extends BackgroundEvent {}

class BackgroundServiceStopped extends BackgroundEvent {}
