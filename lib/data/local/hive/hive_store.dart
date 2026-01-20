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

  Future<Box<Map<dynamic, dynamic>>> openParticipants() async {
    await init();
    return Hive.openBox<Map<dynamic, dynamic>>(participantsBox);
  }

  Future<Box<Map<dynamic, dynamic>>> openTransactions() async {
    await init();
    return Hive.openBox<Map<dynamic, dynamic>>(transactionsBox);
  }

  Future<Box<Map<dynamic, dynamic>>> openSettings() async {
    await init();
    return Hive.openBox<Map<dynamic, dynamic>>(settingsBox);
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
