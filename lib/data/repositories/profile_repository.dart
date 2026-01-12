import '../local/hive/hive_store.dart';
import '../local/hive/profile_dao.dart';
import '../models/user_profile.dart';

class ProfileRepository {
  ProfileRepository({required HiveStore hive}) : _hive = hive;

  final HiveStore _hive;

  Future<UserProfile?> getProfile() async {
    final box = await _hive.openSettings();
    return ProfileDao(box).getProfile();
  }

  Future<void> upsertProfile(UserProfile profile) async {
    final box = await _hive.openSettings();
    await ProfileDao(box).upsertProfile(profile);
  }

  Future<void> deleteProfile() async {
    final box = await _hive.openSettings();
    await ProfileDao(box).deleteProfile();
  }
}

