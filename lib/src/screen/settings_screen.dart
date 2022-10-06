import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/settings_bloc.dart';
import 'widget/settings_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Container(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 4.0),
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) => ListView(
            itemExtent: 70.0,
            children: [
              SettingsTile(
                title: 'Licenses',
                subtitle: 'Show licenses and app details',
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: 'Note App',
                  applicationVersion: 'v2.0.2',
                  applicationIcon: const Image(
                    image: AssetImage('asset/icon/launcher_icon.png'),
                    width: 64.0,
                    height: 64.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
