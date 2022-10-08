import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app.dart';
//import 'src/repository/notes_repository.dart';
import 'src/repository/settings_repository.dart';

void main() {
  // TODO: Activate later
  //GoogleFonts.config.allowRuntimeFetching = false;

  LicenseRegistry.addLicense(() async* {
    final license =
        await rootBundle.loadString('asset/google_fonts/LICENSE.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SettingsRepository>(
          create: (_) => SettingsRepository(),
        ),
        /* RepositoryProvider<NotesRepository>(
          create: (_) => NotesRepository(),
        ), */
      ],
      child: const App(),
    ),
  );
}
