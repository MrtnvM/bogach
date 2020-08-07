import 'package:shared_preferences/shared_preferences.dart';

class LaunchCounter {
  LaunchCounter(this.preferences);

  final SharedPreferences preferences;
  final _launchCountKey = 'APP_LAUNCH_COUNT';

  int getLaunchCount() {
    return preferences.getInt(_launchCountKey) ?? 0;
  }

  bool isFirstLaunch() {
    return getLaunchCount() == 0;
  }

  Future<void> incrementLaunchCount() async {
    final count = getLaunchCount() + 1;
    await preferences.setInt(_launchCountKey, count);
  }
}
