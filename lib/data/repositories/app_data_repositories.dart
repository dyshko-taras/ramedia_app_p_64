import '../local/hive/hive_store.dart';
import '../local/prefs_store.dart';
import 'participants_repository.dart';
import 'profile_repository.dart';
import 'settings_repository.dart';
import 'transactions_repository.dart';

class AppDataRepositories {
  AppDataRepositories({
    required this.profile,
    required this.participants,
    required this.transactions,
    required this.settings,
  });

  final ProfileRepository profile;
  final ParticipantsRepository participants;
  final TransactionsRepository transactions;
  final SettingsRepository settings;

  static Future<AppDataRepositories> create() async {
    final prefs = await PrefsStore.load();
    final hive = HiveStore();

    return AppDataRepositories(
      profile: ProfileRepository(hive: hive),
      participants: ParticipantsRepository(hive: hive),
      transactions: TransactionsRepository(hive: hive),
      settings: SettingsRepository(
        prefs: prefs,
        hive: hive,
      ),
    );
  }
}

