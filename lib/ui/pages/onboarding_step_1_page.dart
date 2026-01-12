import 'package:flutter/material.dart';

import '../../constants/app_strings.dart';

class OnboardingStep1Page extends StatelessWidget {
  const OnboardingStep1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text(AppStrings.onboardingStep1Title)),
    );
  }
}

