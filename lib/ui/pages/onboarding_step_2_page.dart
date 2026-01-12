import 'package:flutter/material.dart';

import '../../constants/app_strings.dart';

class OnboardingStep2Page extends StatelessWidget {
  const OnboardingStep2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text(AppStrings.onboardingStep2Title)),
    );
  }
}

