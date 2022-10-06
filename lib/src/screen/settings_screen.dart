import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../bloc/settings_bloc.dart';
import '../string_extension.dart';
import 'widget/settings_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

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
                  applicationName: '${_packageInfo.appName.capitalize()} App',
                  applicationVersion: 'v${_packageInfo.version}',
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
