import 'package:equatable/equatable.dart';

class SplashState extends Equatable {
  const SplashState._({
    required this.status,
    this.nextRoute,
  });

  const SplashState.loading() : this._(status: SplashStatus.loading);

  const SplashState.navigate({
    required String nextRoute,
  }) : this._(
          status: SplashStatus.navigate,
          nextRoute: nextRoute,
        );

  final SplashStatus status;
  final String? nextRoute;

  @override
  List<Object?> get props => [status, nextRoute];
}

enum SplashStatus {
  loading,
  navigate,
}

