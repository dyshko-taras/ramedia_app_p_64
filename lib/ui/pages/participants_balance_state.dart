import 'package:equatable/equatable.dart';

import '../../data/models/participant.dart';

class ParticipantsBalanceState extends Equatable {
  const ParticipantsBalanceState({
    required this.isLoading,
    required this.participants,
    required this.balancesByParticipantId,
    required this.debts,
  });

  const ParticipantsBalanceState.initial()
    : isLoading = true,
      participants = const [],
      balancesByParticipantId = const {},
      debts = const [];

  final bool isLoading;
  final List<Participant> participants;
  final Map<String, int> balancesByParticipantId;
  final List<Debt> debts;

  bool get hasDebts => debts.isNotEmpty;

  ParticipantsBalanceState copyWith({
    bool? isLoading,
    List<Participant>? participants,
    Map<String, int>? balancesByParticipantId,
    List<Debt>? debts,
  }) {
    return ParticipantsBalanceState(
      isLoading: isLoading ?? this.isLoading,
      participants: participants ?? this.participants,
      balancesByParticipantId:
          balancesByParticipantId ?? this.balancesByParticipantId,
      debts: debts ?? this.debts,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    participants,
    balancesByParticipantId,
    debts,
  ];
}

class Debt extends Equatable {
  const Debt({
    required this.fromParticipantId,
    required this.toParticipantId,
    required this.amountMinor,
  });

  final String fromParticipantId;
  final String toParticipantId;
  final int amountMinor;

  @override
  List<Object?> get props => [fromParticipantId, toParticipantId, amountMinor];
}
