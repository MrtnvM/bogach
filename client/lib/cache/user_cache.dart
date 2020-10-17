import 'dart:convert';

import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserCache {
  const UserCache(this._secureStorage);

  static const _userProfileKey = 'current_user_profile';

  final FlutterSecureStorage _secureStorage;

  Future<UserProfile> getUserProfile() async {
    final jsonString = await _secureStorage.read(key: _userProfileKey);
    if (jsonString == null) {
      return null;
    }

    final jsonData = json.decode(jsonString);
    final profile = UserProfile.fromJson(jsonData);
    return profile;
  }

  Future<void> setUserProfile(UserProfile profile) async {
    final jsonData = profile.toJson();
    final jsonString = json.encode(jsonData);
    await _secureStorage.write(key: _userProfileKey, value: jsonString);
  }

  Future<void> deleteUserProfile() async {
    await _secureStorage.delete(key: _userProfileKey);
  }
}
