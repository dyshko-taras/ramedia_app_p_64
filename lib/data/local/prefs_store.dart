import 'package:shared_preferences/shared_preferences.dart';

class PrefsStore {
  static const _keyOnboardingCompleted = 'onboarding_completed';
  static const _keySelectedCurrencyCode = 'selected_currency_code';

  PrefsStore(this._prefs);

  final SharedPreferences _prefs;

  static Future<PrefsStore> load() async {
    final prefs = await SharedPreferences.getInstance();
    return PrefsStore(prefs);
  }

  bool getOnboardingCompleted() =>
      _prefs.getBool(_keyOnboardingCompleted) ?? false;

  Future<void> setOnboardingCompleted(bool value) async {
    await _prefs.setBool(_keyOnboardingCompleted, value);
  }

  String? getSelectedCurrencyCode() => _prefs.getString(_keySelectedCurrencyCode);

  Future<void> setSelectedCurrencyCode(String code) async {
    await _prefs.setString(_keySelectedCurrencyCode, code);
  }

  Future<void> clearAll() => _prefs.clear();
}

