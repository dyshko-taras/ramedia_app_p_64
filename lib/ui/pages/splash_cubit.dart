import 'package:bloc/bloc.dart';

import '../../constants/app_durations.dart';
import '../../constants/app_routes.dart';
import '../../data/repositories/settings_repository.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({
    required SettingsRepository settings,
  })  : _settings = settings,
        super(const SplashState.loading());

  final SettingsRepository _settings;

  Future<void> bootstrap() async {
    final startedAt = DateTime.now();

    final onboardingCompleted = _settings.getOnboardingCompleted();

    final nextRoute = onboardingCompleted
        ? AppRoutes.home
        : AppRoutes.onboardingStep1;

    final elapsed = DateTime.now().difference(startedAt);
    final remaining = AppDurations.splashMin - elapsed;
    if (!remaining.isNegative) {
      await Future<void>.delayed(remaining);
    }

    emit(SplashState.navigate(nextRoute: nextRoute));
  }
}
