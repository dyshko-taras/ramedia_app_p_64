import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_images.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_strings.dart';
import '../../data/repositories/settings_repository.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'onboarding_step_1_cubit.dart';
import 'onboarding_step_1_state.dart';

class OnboardingStep1Page extends StatelessWidget {
  const OnboardingStep1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          OnboardingStep1Cubit(settings: context.read<SettingsRepository>()),
      child: BlocListener<OnboardingStep1Cubit, OnboardingStep1State>(
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == OnboardingStep1Status.navigate,
        listener: (context, state) {
          final next = state.nextRoute;
          if (next == null) return;
          Navigator.of(context).pushReplacementNamed(next);
        },
        child: const PopScope(
          canPop: false,
          child: Scaffold(
            body: _OnboardingStep1View(),
          ),
        ),
      ),
    );
  }
}

class _OnboardingStep1View extends StatelessWidget {
  const _OnboardingStep1View();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          AppImages.onboardingStep1Background,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const ColoredBox(color: AppColors.background2),
        ),
        SafeArea(
          child: Padding(
            padding: Insets.allLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.onboardingStep1Title,
                  style: AppTextStyles.header1.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Gaps.hMd,
                Text(
                  AppStrings.onboardingStep1Subtitle,
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Gaps.hXl,
                const _ContinueButton(),
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingStep1Cubit, OnboardingStep1State>(
      builder: (context, state) {
        final isLoading = state.status == OnboardingStep1Status.submitting;
        return SizedBox(
          height: AppSizes.buttonHeight,
          width: double.infinity,
          child: FilledButton(
            onPressed: isLoading
                ? null
                : () => context.read<OnboardingStep1Cubit>().onContinue(),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accentSecondary,
              foregroundColor: AppColors.textPrimary,
              shape: const RoundedRectangleBorder(borderRadius: AppRadius.xl),
            ),
            child: isLoading
                ? const SizedBox(
                    height: AppSizes.loadingIndicatorSize,
                    width: AppSizes.loadingIndicatorSize,
                    child: CircularProgressIndicator(
                      strokeWidth: AppSizes.loadingIndicatorStrokeWidth,
                    ),
                  )
                : const Text(AppStrings.commonContinue),
          ),
        );
      },
    );
  }
}
