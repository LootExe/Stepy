part of 'settings_bloc.dart';

abstract class SettingsEvent {}

class SettingsLoaded extends SettingsEvent {}

class SettingsChanged extends SettingsEvent {}
