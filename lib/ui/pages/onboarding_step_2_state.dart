import 'package:equatable/equatable.dart';

import '../../data/models/currency.dart';
import '../../data/models/participant.dart';
import '../../data/models/user_profile.dart';

class OnboardingStep2State extends Equatable {
  const OnboardingStep2State({
    required this.isLoading,
    required this.profile,
    required this.participants,
    required this.selectedCurrency,
    required this.isCurrencyDropdownOpen,
    required this.isSubmitting,
    required this.message,
    required this.messageVersion,
    required this.nextRoute,
    required this.navigationVersion,
  });

  const OnboardingStep2State.initial()
      : isLoading = true,
        profile = null,
        participants = const [],
        selectedCurrency = null,
        isCurrencyDropdownOpen = false,
        isSubmitting = false,
        message = null,
        messageVersion = 0,
        nextRoute = null,
        navigationVersion = 0;

  final bool isLoading;
  final UserProfile? profile;
  final List<Participant> participants;
  final Currency? selectedCurrency;
  final bool isCurrencyDropdownOpen;
  final bool isSubmitting;
  final String? message;
  final int messageVersion;
  final String? nextRoute;
  final int navigationVersion;

  bool get canAddParticipant => participants.length < 10;
  bool get canContinue =>
      !isLoading && !isSubmitting && profile != null && selectedCurrency != null;

  OnboardingStep2State copyWith({
    bool? isLoading,
    UserProfile? profile,
    List<Participant>? participants,
    Currency? selectedCurrency,
    bool? isCurrencyDropdownOpen,
    bool? isSubmitting,
    String? message,
    int? messageVersion,
    String? nextRoute,
    int? navigationVersion,
    bool clearMessage = false,
    bool clearNextRoute = false,
  }) {
    return OnboardingStep2State(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      participants: participants ?? this.participants,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      isCurrencyDropdownOpen:
          isCurrencyDropdownOpen ?? this.isCurrencyDropdownOpen,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      message: clearMessage ? null : (message ?? this.message),
      messageVersion: messageVersion ?? this.messageVersion,
      nextRoute: clearNextRoute ? null : (nextRoute ?? this.nextRoute),
      navigationVersion: navigationVersion ?? this.navigationVersion,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        profile,
        participants,
        selectedCurrency,
        isCurrencyDropdownOpen,
        isSubmitting,
        message,
        messageVersion,
        nextRoute,
        navigationVersion,
      ];
}
