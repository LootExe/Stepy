import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/settings_bloc.dart';
import 'widget/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

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
                title: 'Settings Tile',
                subtitle: 'Click to change something',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
