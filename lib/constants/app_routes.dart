import 'package:flutter/widgets.dart';

import '../ui/pages/credit_page.dart';
import '../ui/pages/home_page.dart';
import '../ui/pages/main_shell_page.dart';
import '../ui/pages/no_internet_page.dart';
import '../ui/pages/onboarding_step_1_page.dart';
import '../ui/pages/onboarding_step_2_page.dart';
import '../ui/pages/participants_balance_page.dart';
import '../ui/pages/settings_page.dart';
import '../ui/pages/splash_page.dart';

abstract final class AppRoutes {
  static const main = '/';
  static const splash = '/splash';
  static const onboardingStep1 = '/onboarding/step-1';
  static const onboardingStep2 = '/onboarding/step-2';

  static const home = '/home';
  static const credit = '/credit';
  static const settings = '/settings';

  static const participantsBalance = '/participants-balance';
  static const noInternet = '/no-internet';

  static Map<String, WidgetBuilder> routes = {
    main: (_) => const MainShellPage(),
    splash: (_) => const SplashPage(),
    onboardingStep1: (_) => const OnboardingStep1Page(),
    onboardingStep2: (_) => const OnboardingStep2Page(),
    home: (_) => const MainShellPage(initialIndex: 0),
    credit: (_) => const MainShellPage(initialIndex: 1),
    settings: (_) => const MainShellPage(initialIndex: 2),
    participantsBalance: (_) => const ParticipantsBalancePage(),
    noInternet: (_) => const NoInternetPage(),
  };

  static const tabPages = <Widget>[
    HomePage(),
    CreditPage(),
    SettingsPage(),
  ];
}

