import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app_info_bloc.dart';
import '../extensions.dart';
import 'widget/settings_tile.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);
  Widget _getAppIcon(AssetImage? image) {
    if (image == null) {
      return const Icon(Icons.error_outline);
    } else {
      return Image(
        image: image,
        width: 64.0,
        height: 64.0,
      );
    }
  }

  // TODO: Add more text, like description of foreground service
  // alarm manager, etc.
  // Provide Github link to source
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Container(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 4.0),
        child: BlocBuilder<AppInfoBloc, AppInfoState>(
          builder: (context, state) => ListView(
            itemExtent: 70.0,
            children: [
              SettingsTile(
                title: 'Licenses',
                subtitle: 'Show licenses and app details',
                onTap: () => showLicensePage(
                  context: context,
                  applicationName:
                      '${state.information.packageInfo?.appName.capitalize()} App',
                  applicationVersion:
                      'v${state.information.packageInfo?.version}',
                  applicationIcon: _getAppIcon(state.information.appIcon),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
