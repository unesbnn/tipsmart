import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../keys/keys.dart';


class OneSignalNotification {
  static Future<void> initializeOneSignal() async {
    // OneSignal.Debug.setLogLevel(OSLogLevel.none);
    OneSignal.initialize(Keys.oneSignalAppId);
  }
}
