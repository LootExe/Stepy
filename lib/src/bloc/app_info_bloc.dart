import 'package:bloc/bloc.dart';
import 'package:stepy/src/model/app_info_data.dart';

import '../repository/app_info_repository.dart';

part 'app_info_state.dart';
part 'app_info_event.dart';

class AppInfoBloc extends Bloc<AppInfoEvent, AppInfoState> {
  AppInfoBloc({required AppInfoRepository repository})
      : _repository = repository,
        super(AppInfoInitial(repository.information)) {
    on<AppInfoLoaded>(_onLoaded);
  }

  final AppInfoRepository _repository;

  AppInfoData get appInformation => _repository.information;

  Future<void> _onLoaded(
      AppInfoLoaded event, Emitter<AppInfoState> emit) async {
    emit(AppInfoLoadSuccess(appInformation));
  }
}
