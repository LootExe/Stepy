import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/model/app_initialize_data.dart';

import 'src/bloc/background_bloc.dart';
import 'src/bloc/settings_bloc.dart';
import 'src/bloc/pedometer_bloc.dart';

import 'src/repository/history_repository.dart';
import 'src/repository/pedometer_repository.dart';
import 'src/repository/settings_repository.dart';

import 'src/screen/home_screen.dart';
import 'src/screen/permission_screen.dart';

import 'src/theme_manager.dart';

class App extends StatelessWidget {
  const App({super.key, required this.initData});

  final AppInitializeData initData;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              SettingsBloc(RepositoryProvider.of<SettingsRepository>(context)),
        ),
        BlocProvider(
          create: (context) => PedometerBloc(
            pedometer: RepositoryProvider.of<PedometerRepository>(context),
            history: RepositoryProvider.of<HistoryRepository>(context),
          ),
        ),
        BlocProvider(
          create: (context) => BackgroundBloc(
            isRunning: initData.isForegroundRunning,
          ),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) => MaterialApp(
          theme: ThemeManager.lightTheme,
          darkTheme: ThemeManager.darkTheme,
          themeMode: ThemeMode.dark,
          home: initData.isPedometerPermissionGranted
              ? const HomeScreen()
              : const PermissionScreen(),
        ),
      ),
    );
  }
}
