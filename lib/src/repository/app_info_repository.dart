import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../model/app_info_data.dart';

class AppInfoRepository {
  var information = AppInfoData();

  Future<void> readInformation() async {
    information.packageInfo = await PackageInfo.fromPlatform();
    information.appIcon = const AssetImage('asset/icon/launcher_icon.png');
  }
}
