import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';

import 'src/bloc/background_bloc.dart';
import 'src/bloc/pedometer_bloc.dart';

import 'src/model/app_initialize_data.dart';
import 'src/model/log_data.dart';
import 'src/model/step_data.dart';

import 'src/provider/hive_database.dart';
import 'src/provider/pedometer_sensor.dart';
import 'src/provider/preferences_storage.dart';

import 'src/repository/history_repository.dart';
import 'src/repository/pedometer_repository.dart';
import 'src/repository/settings_repository.dart';

void main() async {
  GoogleFonts.config.allowRuntimeFetching = false;

  runApp(const Center(
    child: SizedBox(
      width: 64,
      height: 64,
      child: CircularProgressIndicator(
        color: Colors.greenAccent,
      ),
    ),
  ));

  // Add additional licenses
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('asset/google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  // Create all data repositories
  final settings = SettingsRepository(
    storage: PreferencesStorage(),
  );

  final pedometer = PedometerRepository(
    storage: PreferencesStorage(),
    sensor: PedometerSensor(),
  );

  final history = HistoryRepository(
    database: HiveDatabase(boxName: StepData.boxName),
  );

  // Hive register adapters
  Hive.registerAdapter(StepDataAdapter());
  Hive.registerAdapter(LogDataAdapter());
  await Hive.initFlutter();

  // Await all async operations
  await Future.wait([
    // Set system orientation to portrait only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]),

    // Load repository data
    settings.readSettings(),
    pedometer.initialize(),
    history.initialize(),

    // Initialize alarm manager plugin
    BackgroundBloc.initializeAlarmManager(),
  ]);

  final appInitData = AppInitializeData(
    isForegroundRunning: await BackgroundBloc.isServiceRunning,
    isPedometerPermissionGranted: await PedometerBloc.isPermissionGranted,
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SettingsRepository>(create: (_) => settings),
        RepositoryProvider<PedometerRepository>(create: (_) => pedometer),
        RepositoryProvider<HistoryRepository>(create: (_) => history),
      ],
      child: App(initData: appInitData),
    ),
  );
}
