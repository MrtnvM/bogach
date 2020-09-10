import 'dart:convert';

import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCache {
  const UserCache(this._preferences);

  static const _userProfileKey = 'current_user_profile';

  final SharedPreferences _preferences;

  UserProfile getUserProfile() {
    final jsonString = _preferences.getString(_userProfileKey);
    if (jsonString == null) {
      return null;
    }

    final jsonData = json.decode(jsonString);
    final profile = UserProfile.fromJson(jsonData);
    return profile;
  }

  void setUserProfile(UserProfile profile) {
    final jsonData = profile.toJson();
    final jsonString = json.encode(jsonData);
    _preferences.setString(_userProfileKey, jsonString);
  }

  void deleteUserProfile() {
    _preferences.remove(_userProfileKey);
  }
}
