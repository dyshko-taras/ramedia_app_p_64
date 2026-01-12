import 'package:hive_flutter/hive_flutter.dart';

class HiveStore {
  static const participantsBox = 'participants';
  static const transactionsBox = 'transactions';
  static const settingsBox = 'settings';

  static bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    await Hive.initFlutter();
    _initialized = true;
  }

  Future<Box<Map<String, Object?>>> openParticipants() async {
    await init();
    return Hive.openBox<Map<String, Object?>>(participantsBox);
  }

  Future<Box<Map<String, Object?>>> openTransactions() async {
    await init();
    return Hive.openBox<Map<String, Object?>>(transactionsBox);
  }

  Future<Box<Map<String, Object?>>> openSettings() async {
    await init();
    return Hive.openBox<Map<String, Object?>>(settingsBox);
  }

  Future<void> clearAll() async {
    await init();
    if (await Hive.boxExists(participantsBox)) {
      await Hive.deleteBoxFromDisk(participantsBox);
    }
    if (await Hive.boxExists(transactionsBox)) {
      await Hive.deleteBoxFromDisk(transactionsBox);
    }
    if (await Hive.boxExists(settingsBox)) {
      await Hive.deleteBoxFromDisk(settingsBox);
    }
  }
}
