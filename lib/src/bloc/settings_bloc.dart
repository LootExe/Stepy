import 'package:bloc/bloc.dart';

import '../model/settings_data.dart';
import '../repository/settings_repository.dart';

part 'settings_state.dart';
part 'settings_event.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(SettingsRepository repository)
      : _repository = repository,
        super(SettingsInitial(repository.settings)) {
    on<SettingsLoaded>(_onLoaded);
    on<SettingsChanged>(_onChanged);
  }

  final SettingsRepository _repository;

  SettingsData get settings => _repository.settings;

  Future<void> _onLoaded(
      SettingsLoaded event, Emitter<SettingsState> emit) async {
    emit(SettingsLoadSuccess(settings));
  }

  Future<void> _onChanged(
      SettingsChanged event, Emitter<SettingsState> emit) async {
    await _repository.writeSettings();

    emit(SettingsChangeSuccess(settings));
  }
}
