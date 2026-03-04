import 'package:equatable/equatable.dart';

import 'currency.dart';

enum TransactionType {
  income,
  expense,
}

class BudgetTransaction extends Equatable {
  const BudgetTransaction({
    required this.id,
    required this.type,
    required this.participantId,
    required this.amountMinor,
    required this.currency,
    required this.scheduledAt,
    this.isSplit = false,
    this.splitMinorByParticipantId,
    this.borrowFromParticipantId,
    this.borrowedMinor,
  });

  final String id;
  final TransactionType type;
  final String participantId;
  final int amountMinor;
  final Currency currency;
  final DateTime scheduledAt;

  final bool isSplit;
  final Map<String, int>? splitMinorByParticipantId;

  /// When an expense exceeds the payer balance, the missing amount can be
  /// covered by another participant. This represents "who the payer borrowed
  /// from" and how much is owed (in minor units).
  ///
  /// Note: balances are still computed from `splitMinorByParticipantId`, while
  /// debts UI uses these fields to show "owes" even when net balances don't go
  /// negative.
  final String? borrowFromParticipantId;
  final int? borrowedMinor;

  Map<String, Object?> toMap() => {
        'id': id,
        'type': type.name,
        'participantId': participantId,
        'amountMinor': amountMinor,
        'currency': currency.code,
        'scheduledAt': scheduledAt.toIso8601String(),
        'isSplit': isSplit,
        'splitMinorByParticipantId': splitMinorByParticipantId,
        'borrowFromParticipantId': borrowFromParticipantId,
        'borrowedMinor': borrowedMinor,
      };

  static BudgetTransaction fromMap(Map<Object?, Object?> map) {
    final scheduledAtRaw = map['scheduledAt'] as String?;
    return BudgetTransaction(
      id: (map['id'] as String?) ?? '',
      type: TransactionType.values.byName(
        (map['type'] as String?) ?? TransactionType.expense.name,
      ),
      participantId: (map['participantId'] as String?) ?? '',
      amountMinor: (map['amountMinor'] as int?) ?? 0,
      currency: CurrencyX.fromCode((map['currency'] as String?) ?? 'USD'),
      scheduledAt: scheduledAtRaw == null
          ? DateTime.fromMillisecondsSinceEpoch(0)
          : DateTime.parse(scheduledAtRaw),
      isSplit: (map['isSplit'] as bool?) ?? false,
      splitMinorByParticipantId:
          (map['splitMinorByParticipantId'] as Map?)?.cast<String, int>(),
      borrowFromParticipantId: map['borrowFromParticipantId'] as String?,
      borrowedMinor: map['borrowedMinor'] as int?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        participantId,
        amountMinor,
        currency,
        scheduledAt,
        isSplit,
        splitMinorByParticipantId,
        borrowFromParticipantId,
        borrowedMinor,
      ];
}
