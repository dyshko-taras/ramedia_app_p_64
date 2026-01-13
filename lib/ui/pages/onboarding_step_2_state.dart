import 'package:equatable/equatable.dart';

import '../../data/models/currency.dart';
import '../../data/models/participant.dart';
import '../../data/models/user_profile.dart';

class OnboardingStep2State extends Equatable {
  const OnboardingStep2State({
    required this.profile,
    required this.participants,
    required this.selectedCurrency,
    required this.isLoading,
    required this.isSubmitting,
    required this.messageVersion,
    this.message,
    this.nextRoute,
  });

  const OnboardingStep2State.initial()
      : profile = null,
        participants = const [],
        selectedCurrency = null,
        isLoading = true,
        isSubmitting = false,
        message = null,
        messageVersion = 0,
        nextRoute = null;

  final UserProfile? profile;
  final List<Participant> participants;
  final Currency? selectedCurrency;
  final bool isLoading;
  final bool isSubmitting;

  final String? message;
  final int messageVersion;
  final String? nextRoute;

  bool get canContinue =>
      !isLoading &&
      !isSubmitting &&
      profile != null &&
      (selectedCurrency != null);

  bool get canAddParticipant => participants.length < 10;

  OnboardingStep2State copyWith({
    UserProfile? profile,
    List<Participant>? participants,
    Currency? selectedCurrency,
    bool? isLoading,
    bool? isSubmitting,
    String? message,
    int? messageVersion,
    String? nextRoute,
    bool clearMessage = false,
    bool clearNextRoute = false,
  }) {
    return OnboardingStep2State(
      profile: profile ?? this.profile,
      participants: participants ?? this.participants,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      message: clearMessage ? null : (message ?? this.message),
      messageVersion: messageVersion ?? this.messageVersion,
      nextRoute: clearNextRoute ? null : (nextRoute ?? this.nextRoute),
    );
  }

  @override
  List<Object?> get props => [
        profile,
        participants,
        selectedCurrency,
        isLoading,
        isSubmitting,
        message,
        messageVersion,
        nextRoute,
      ];
}

