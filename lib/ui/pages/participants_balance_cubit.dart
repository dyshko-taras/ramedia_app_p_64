import 'package:bloc/bloc.dart';

import '../../data/models/budget_transaction.dart';
import '../../data/models/participant.dart';
import '../../data/repositories/participants_repository.dart';
import '../../data/repositories/transactions_repository.dart';
import 'participants_balance_state.dart';

class ParticipantsBalanceCubit extends Cubit<ParticipantsBalanceState> {
  ParticipantsBalanceCubit({
    required ParticipantsRepository participantsRepository,
    required TransactionsRepository transactionsRepository,
  }) : _participantsRepository = participantsRepository,
       _transactionsRepository = transactionsRepository,
       super(const ParticipantsBalanceState.initial());

  final ParticipantsRepository _participantsRepository;
  final TransactionsRepository _transactionsRepository;

  Future<void> load() async {
    final participants = await _participantsRepository.getAll();
    final transactions = await _transactionsRepository.getAll();
    transactions.sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));

    final balancesByParticipantId = _computeBalancesByParticipantId(
      participants,
      transactions,
    );
    final debts = _mergeDebts(
      [
        ..._computeBalanceDebts(balancesByParticipantId),
        ..._computeBorrowDebts(transactions),
      ],
    );

    emit(
      state.copyWith(
        isLoading: false,
        participants: participants,
        balancesByParticipantId: balancesByParticipantId,
        debts: debts,
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
    await load();
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

  List<Debt> _computeBalanceDebts(Map<String, int> balancesByParticipantId) {
    final creditors = <_BalanceBucket>[];
    final debtors = <_BalanceBucket>[];

    for (final entry in balancesByParticipantId.entries) {
      final amount = entry.value;
      if (amount > 0) {
        creditors.add(_BalanceBucket(id: entry.key, remainingMinor: amount));
      } else if (amount < 0) {
        debtors.add(_BalanceBucket(id: entry.key, remainingMinor: -amount));
      }
    }

    creditors.sort((a, b) => b.remainingMinor.compareTo(a.remainingMinor));
    debtors.sort((a, b) => b.remainingMinor.compareTo(a.remainingMinor));

    final result = <Debt>[];
    var creditorIndex = 0;

    for (final debtor in debtors) {
      while (debtor.remainingMinor > 0 && creditorIndex < creditors.length) {
        final creditor = creditors[creditorIndex];
        final payMinor = debtor.remainingMinor <= creditor.remainingMinor
            ? debtor.remainingMinor
            : creditor.remainingMinor;

        result.add(
          Debt(
            fromParticipantId: debtor.id,
            toParticipantId: creditor.id,
            amountMinor: payMinor,
          ),
        );

        debtor.remainingMinor -= payMinor;
        creditor.remainingMinor -= payMinor;
        if (creditor.remainingMinor <= 0) {
          creditorIndex += 1;
        }
      }
    }

    return result;
  }

  List<Debt> _computeBorrowDebts(List<BudgetTransaction> transactions) {
    final result = <Debt>[];
    for (final t in transactions) {
      if (t.type != TransactionType.expense) continue;
      final lenderId = t.borrowFromParticipantId;
      final borrowedMinor = t.borrowedMinor;
      if (lenderId == null || lenderId.isEmpty) continue;
      if (borrowedMinor == null || borrowedMinor <= 0) continue;

      result.add(
        Debt(
          fromParticipantId: t.participantId,
          toParticipantId: lenderId,
          amountMinor: borrowedMinor,
        ),
      );
    }
    return result;
  }

  List<Debt> _mergeDebts(List<Debt> debts) {
    if (debts.isEmpty) return const [];

    final merged = <String, int>{};
    for (final d in debts) {
      if (d.amountMinor <= 0) continue;
      final key = '${d.fromParticipantId}|${d.toParticipantId}';
      merged.update(
        key,
        (v) => v + d.amountMinor,
        ifAbsent: () => d.amountMinor,
      );
    }

    final result = <Debt>[];
    for (final entry in merged.entries) {
      final parts = entry.key.split('|');
      if (parts.length != 2) continue;
      result.add(
        Debt(
          fromParticipantId: parts[0],
          toParticipantId: parts[1],
          amountMinor: entry.value,
        ),
      );
    }

    result.sort((a, b) => b.amountMinor.compareTo(a.amountMinor));
    return result;
  }
}

class _BalanceBucket {
  _BalanceBucket({
    required this.id,
    required this.remainingMinor,
  });

  final String id;
  int remainingMinor;
}
