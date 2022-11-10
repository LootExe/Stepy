part of 'app_info_bloc.dart';

abstract class AppInfoState {
  const AppInfoState(this.information);

  final AppInfoData information;
}

class AppInfoInitial extends AppInfoState {
  const AppInfoInitial(AppInfoData information) : super(information);
}

class AppInfoLoadSuccess extends AppInfoState {
  AppInfoLoadSuccess(AppInfoData information) : super(information);
}
