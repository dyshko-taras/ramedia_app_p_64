import 'package:hive/hive.dart';

import '../../models/user_profile.dart';
import 'hive_keys.dart';

class ProfileDao {
  ProfileDao(this._box);

  final Box<Map<dynamic, dynamic>> _box;

  UserProfile? getProfile() {
    final map = _box.get(HiveKeys.userProfile);
    if (map == null) return null;
    return UserProfile.fromMap(map.cast<Object?, Object?>());
  }

  Future<void> upsertProfile(UserProfile profile) =>
      _box.put(HiveKeys.userProfile, profile.toMap());

  Future<void> deleteProfile() => _box.delete(HiveKeys.userProfile);
}
