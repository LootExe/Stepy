import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/bloc/settings_bloc.dart';
import 'src/repository/settings_repository.dart';
import 'src/screen/home_screen.dart';
import 'src/theme_manager.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  Future<bool> _loadData(BuildContext context) async {
    await Future.wait([
      RepositoryProvider.of<SettingsRepository>(context).readSettings(),
      //RepositoryProvider.of<NotesRepository>(context).readNotes(),
    ]);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return FutureBuilder(
      future: _loadData(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => SettingsBloc(
                    repository:
                        RepositoryProvider.of<SettingsRepository>(context)),
              ),
              /* BlocProvider(
                create: (context) => NoteListBloc(
                    RepositoryProvider.of<NotesRepository>(context)),
              ), */
            ],
            child: BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) => MaterialApp(
                theme: ThemeManager.lightTheme,
                darkTheme: ThemeManager.darkTheme,
                themeMode: ThemeMode.dark,
                home: HomeScreen(),
              ),
            ),
          );
        } else {
          return const Center(
            child: SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
