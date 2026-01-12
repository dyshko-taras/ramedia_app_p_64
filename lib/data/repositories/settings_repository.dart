import '../local/hive/hive_store.dart';
import '../local/prefs_store.dart';

class SettingsRepository {
  SettingsRepository({
    required PrefsStore prefs,
    required HiveStore hive,
  })  : _prefs = prefs,
        _hive = hive;

  final PrefsStore _prefs;
  final HiveStore _hive;

  bool getOnboardingCompleted() => _prefs.getOnboardingCompleted();
  Future<void> setOnboardingCompleted(bool value) =>
      _prefs.setOnboardingCompleted(value);

  String? getSelectedCurrencyCode() => _prefs.getSelectedCurrencyCode();
  Future<void> setSelectedCurrencyCode(String code) =>
      _prefs.setSelectedCurrencyCode(code);

  Future<void> clearAllData() async {
    await _prefs.clearAll();
    await _hive.clearAll();
  }
}

