import 'package:cash_flow/utils/error_handler.dart';
import 'package:cash_flow/utils/versions.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const lastAppVersion = 'last_app_version';

class UpdatesService {
  UpdatesService({
    required this.remoteConfig,
    required this.preferences,
  }) {
    if (!preferences.containsKey(lastAppVersion)) {
      remoteConfig.setDefaults({
        lastAppVersion: '-1',
      });
      return;
    }
    remoteConfig.setDefaults({
      lastAppVersion: preferences.getString(lastAppVersion),
    });
  }

  final RemoteConfig remoteConfig;
  final SharedPreferences preferences;

  Future<String> getLastAppVersion() async {
    try {
      await remoteConfig.fetch();
      final updated = await remoteConfig.fetchAndActivate();
      final lastAppVersionValue = remoteConfig.getString(lastAppVersion);
      if (updated) {
        preferences.setString(lastAppVersion, lastAppVersionValue);
      }
      return lastAppVersionValue;
    } catch (error) {
      recordError(error);
      rethrow;
    }
  }

  Future<void> checkUpdates(VoidCallback updateApp) async {
    final lastVersion = await getLastAppVersion();
    final currentVersion = await getAppVersion();

    if (!isCurrentVersionLast(currentVersion, lastVersion)) {
      updateApp();
    }
  }
}
