import 'dart:io';

import 'package:package_info/package_info.dart';
import 'package:version/version.dart';

Future<String> getAppVersion() async {
  final packageInfo = await PackageInfo.fromPlatform();
  final version = packageInfo.version;

  if (Platform.isAndroid) {
    return version.split('-')[0];
  }

  return version;
}

Future<String> getCodeVersion() async {
  final packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.buildNumber;
}

bool isCurrentVersionLast(String current, String last) {
  return Version.parse(current) >= Version.parse(last);
}
