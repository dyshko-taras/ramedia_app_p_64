import 'package:bloc/bloc.dart';

import '../../data/models/budget_transaction.dart';
import '../../data/models/currency.dart';
import '../../data/models/participant.dart';
import '../../data/repositories/participants_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/repositories/transactions_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required ProfileRepository profileRepository,
    required ParticipantsRepository participantsRepository,
    required TransactionsRepository transactionsRepository,
    required SettingsRepository settingsRepository,
  })  : _profileRepository = profileRepository,
        _participantsRepository = participantsRepository,
        _transactionsRepository = transactionsRepository,
        _settingsRepository = settingsRepository,
        super(const HomeState.initial());

  final ProfileRepository _profileRepository;
  final ParticipantsRepository _participantsRepository;
  final TransactionsRepository _transactionsRepository;
  final SettingsRepository _settingsRepository;

  Future<void> load() async {
    final profile = await _profileRepository.getProfile();
    final participants = await _participantsRepository.getAll();
    final transactions = await _getSortedTransactions();
    final totalCents = _computeTotalCents(transactions);
    final balancesByParticipantId =
        _computeBalancesByParticipantId(participants, transactions);

    emit(
      state.copyWith(
        isLoading: false,
        profile: profile,
        participants: participants,
        transactions: transactions,
        totalCents: totalCents,
        balancesByParticipantId: balancesByParticipantId,
      ),
    );
  }

  Future<void> addParticipant({
    required String name,
    String? photoPath,
  }) async {
    final participant = Participant(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      photoPath: photoPath,
      createdAt: DateTime.now(),
    );
    await _participantsRepository.upsert(participant);
    final participants = await _participantsRepository.getAll();
    emit(
      state.copyWith(
        participants: participants,
        balancesByParticipantId:
            _computeBalancesByParticipantId(participants, state.transactions),
      ),
    );
  }

  Future<void> addIncome({
    required String participantId,
    required int amountCents,
    required DateTime scheduledAt,
  }) async {
    if (amountCents <= 0) return;

    final currencyCode = _settingsRepository.getSelectedCurrencyCode() ?? 'USD';
    final currency = CurrencyX.fromCode(currencyCode);

    final tx = BudgetTransaction(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: TransactionType.income,
      participantId: participantId,
      amountMinor: amountCents,
      currency: currency,
      scheduledAt: scheduledAt,
      isSplit: false,
    );

    await _transactionsRepository.upsert(tx);
    final transactions = await _getSortedTransactions();
    emit(
      state.copyWith(
        transactions: transactions,
        totalCents: _computeTotalCents(transactions),
        balancesByParticipantId:
            _computeBalancesByParticipantId(state.participants, transactions),
      ),
    );
  }

  Future<void> addExpense({
    required String participantId,
    required int amountCents,
    required DateTime scheduledAt,
    required bool isSplit,
    Map<String, int>? splitMinorByParticipantIdOverride,
    String? splitWithParticipantId,
    int? splitPercent,
  }) async {
    if (amountCents <= 0) return;

    final currencyCode = _settingsRepository.getSelectedCurrencyCode() ?? 'USD';
    final currency = CurrencyX.fromCode(currencyCode);

    final splitMinorByParticipantId = splitMinorByParticipantIdOverride ??
        _computeSplitMinorByParticipantId(
          participantId: participantId,
          amountCents: amountCents,
          isSplit: isSplit,
          splitWithParticipantId: splitWithParticipantId,
          splitPercent: splitPercent,
        );

    final tx = BudgetTransaction(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: TransactionType.expense,
      participantId: participantId,
      amountMinor: amountCents,
      currency: currency,
      scheduledAt: scheduledAt,
      isSplit: splitMinorByParticipantId != null || isSplit,
      splitMinorByParticipantId: splitMinorByParticipantId,
    );

    await _transactionsRepository.upsert(tx);
    final transactions = await _getSortedTransactions();
    emit(
      state.copyWith(
        transactions: transactions,
        totalCents: _computeTotalCents(transactions),
        balancesByParticipantId:
            _computeBalancesByParticipantId(state.participants, transactions),
      ),
    );
  }

  Future<void> deleteTransaction(String id) async {
    await _transactionsRepository.deleteById(id);
    final transactions = await _getSortedTransactions();
    emit(
      state.copyWith(
        transactions: transactions,
        totalCents: _computeTotalCents(transactions),
        balancesByParticipantId:
            _computeBalancesByParticipantId(state.participants, transactions),
      ),
    );
  }

  Future<List<BudgetTransaction>> _getSortedTransactions() async {
    final transactions = await _transactionsRepository.getAll();
    transactions.sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
    return transactions;
  }

  int _computeTotalCents(List<BudgetTransaction> transactions) {
    var total = 0;
    for (final t in transactions) {
      if (t.type == TransactionType.income) {
        total += t.amountMinor;
      } else {
        total -= t.amountMinor;
      }
    }
    return total;
  }

  Map<String, int>? _computeSplitMinorByParticipantId({
    required String participantId,
    required int amountCents,
    required bool isSplit,
    required String? splitWithParticipantId,
    required int? splitPercent,
  }) {
    if (!isSplit || splitWithParticipantId == null) return null;

    final safePercent = (splitPercent ?? 0).clamp(0, 100);
    final splitWithMinor = ((amountCents * safePercent) / 100).round();
    final payerMinor = amountCents - splitWithMinor;
    return <String, int>{
      participantId: payerMinor,
      splitWithParticipantId: splitWithMinor,
    };
  }

  Map<String, int> _computeBalancesByParticipantId(
    List<Participant> participants,
    List<BudgetTransaction> transactions,
  ) {
    final balances = <String, int>{
      for (final p in participants) p.id: 0,
    };

    for (final t in transactions) {
      if (t.type == TransactionType.income) {
        balances.update(
          t.participantId,
          (value) => value + t.amountMinor,
          ifAbsent: () => t.amountMinor,
        );
        continue;
      }

      final splitMap = t.splitMinorByParticipantId;
      if (t.isSplit && splitMap != null && splitMap.isNotEmpty) {
        for (final entry in splitMap.entries) {
          balances.update(
            entry.key,
            (value) => value - entry.value,
            ifAbsent: () => -entry.value,
          );
        }
        continue;
      }

      balances.update(
        t.participantId,
        (value) => value - t.amountMinor,
        ifAbsent: () => -t.amountMinor,
      );
    }

    return balances;
  }
}
