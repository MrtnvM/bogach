import 'dart:convert';

import 'package:cash_flow/features/config/config_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _configKey = 'APP_CONFIG';

class ConfigService {
  ConfigService({required this.preferences});

  final SharedPreferences preferences;

  Future<ConfigState> loadConfig() async {
    if (!preferences.containsKey(_configKey)) {
      return ConfigState.initial();
    }

    try {
      final jsonString = preferences.getString(_configKey)!;
      final jsonData = json.decode(jsonString);
      final config = ConfigState.fromJson(jsonData);
      return config;
    } catch (error) {
      return ConfigState.initial();
    }
  }

  Future<void> saveConfig(ConfigState config) async {
    final jsonData = config.toJson();
    final jsonString = json.encode(jsonData);
    preferences.setString(_configKey, jsonString);
  }
}
