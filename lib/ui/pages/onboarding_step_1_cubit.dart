import 'package:bloc/bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants/app_routes.dart';
import '../../data/repositories/settings_repository.dart';
import 'onboarding_step_1_state.dart';

class OnboardingStep1Cubit extends Cubit<OnboardingStep1State> {
  OnboardingStep1Cubit({
    required SettingsRepository settings,
  })  : _settings = settings,
        super(const OnboardingStep1State.idle());

  final SettingsRepository _settings;

  Future<void> onContinue() async {
    emit(const OnboardingStep1State.submitting());

    final hasRequested = _settings.getPushPermissionRequested();

    if (!hasRequested) {
      await Permission.notification.request();
      await _settings.setPushPermissionRequested(true);
    }

    emit(
      const OnboardingStep1State.navigate(nextRoute: AppRoutes.onboardingStep2),
    );
  }
}
