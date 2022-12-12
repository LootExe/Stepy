import 'package:flutter/material.dart';

import 'widget/settings_tile.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _assetImage = AssetImage('asset/icon/launcher_icon.png');

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
                applicationName: 'Stepy App',
                applicationVersion: 'v1.0.2',
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
