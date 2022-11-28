import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../extensions.dart';
import 'widget/settings_tile.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  static const _assetImage = AssetImage('asset/icon/launcher_icon.png');

  late PackageInfo _packageInfo;

  Future<void> _getPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  @override
  void initState() {
    super.initState();
    _getPackageInfo();
  }

  // TODO: Add more text, like description of foreground service
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Container(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 4.0),
        child: ListView(
          itemExtent: 70.0,
          children: [
            SettingsTile(
              icon: Icons.lock,
              title: 'Licenses',
              subtitle: 'Show licenses and app details',
              onTap: () => showLicensePage(
                context: context,
                applicationName: '${_packageInfo.appName.capitalize()} App',
                applicationVersion: 'v${_packageInfo.version}',
                applicationIcon:
                    const Image(image: _assetImage, width: 64.0, height: 64.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
