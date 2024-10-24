import 'package:package_info_plus/package_info_plus.dart';

import 'assets.dart';

class AppConfig {
  AppConfig._();

  static late String name;
  static const String appSlogan = 'Your Guide to Winning Bets!';
  static late String packageName;
  static const String icon = Assets.appIcon;
  static const String email = 'azmardev@gmail.com';

  static Future getPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    name = packageInfo.appName;
    packageName = packageInfo.packageName;
  }
}