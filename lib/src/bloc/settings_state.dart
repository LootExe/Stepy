part of 'settings_bloc.dart';

abstract class SettingsState {
  final SettingsData settings;

  const SettingsState(this.settings);
}

class SettingsInitial extends SettingsState {
  const SettingsInitial(SettingsData settings) : super(settings);
}

class SettingsLoadSuccess extends SettingsState {
  SettingsLoadSuccess(SettingsData settings) : super(settings);
}

class SettingsChangeSuccess extends SettingsState {
  SettingsChangeSuccess(SettingsData settings) : super(settings);
}
