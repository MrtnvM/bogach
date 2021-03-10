import 'package:package_info/package_info.dart';

Future<String> getPackageName() async {
  final packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.packageName;
}
