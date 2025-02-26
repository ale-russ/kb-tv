import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PlatformDetails {
  static final PlatformDetails _singleton = PlatformDetails._internal();

  factory PlatformDetails() {
    return _singleton;
  }

  PlatformDetails._internal();

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  bool get isDekstop =>
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.windows;

  bool get isMobile =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  bool get isWeb => kIsWeb;

  Future<bool> isTv() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    bool isDeviceTV =
        androidInfo.systemFeatures.contains('android.software.leanback');
    return isDeviceTV;
  }
}
