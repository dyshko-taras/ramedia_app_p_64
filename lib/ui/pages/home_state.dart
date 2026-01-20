import 'package:equatable/equatable.dart';

import '../../data/models/budget_transaction.dart';
import '../../data/models/participant.dart';
import '../../data/models/user_profile.dart';

class HomeState extends Equatable {
  const HomeState({
    required this.isLoading,
    required this.profile,
    required this.participants,
    required this.transactions,
    required this.totalCents,
    required this.balancesByParticipantId,
  });

  const HomeState.initial()
      : isLoading = true,
        profile = null,
        participants = const [],
        transactions = const [],
        totalCents = 0,
        balancesByParticipantId = const {};

  final bool isLoading;
  final UserProfile? profile;
  final List<Participant> participants;
  final List<BudgetTransaction> transactions;
  final int totalCents;
  final Map<String, int> balancesByParticipantId;

  HomeState copyWith({
    bool? isLoading,
    UserProfile? profile,
    List<Participant>? participants,
    List<BudgetTransaction>? transactions,
    int? totalCents,
    Map<String, int>? balancesByParticipantId,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      participants: participants ?? this.participants,
      transactions: transactions ?? this.transactions,
      totalCents: totalCents ?? this.totalCents,
      balancesByParticipantId:
          balancesByParticipantId ?? this.balancesByParticipantId,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        profile,
        participants,
        transactions,
        totalCents,
        balancesByParticipantId,
      ];
}
