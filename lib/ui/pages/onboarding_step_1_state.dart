import 'package:equatable/equatable.dart';

class OnboardingStep1State extends Equatable {
  const OnboardingStep1State._({
    required this.status,
    this.nextRoute,
  });

  const OnboardingStep1State.idle() : this._(status: OnboardingStep1Status.idle);

  const OnboardingStep1State.submitting()
      : this._(status: OnboardingStep1Status.submitting);

  const OnboardingStep1State.navigate({
    required String nextRoute,
  }) : this._(
          status: OnboardingStep1Status.navigate,
          nextRoute: nextRoute,
        );

  final OnboardingStep1Status status;
  final String? nextRoute;

  @override
  List<Object?> get props => [status, nextRoute];
}

enum OnboardingStep1Status {
  idle,
  submitting,
  navigate,
}

