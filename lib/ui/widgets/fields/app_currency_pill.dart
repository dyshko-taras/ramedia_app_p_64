import 'package:flutter/material.dart';

import '../../../constants/app_radius.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_spacing.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class AppCurrencyPill extends StatelessWidget {
  const AppCurrencyPill({
    required this.currencyCode,
    super.key,
  });

  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.buttonHeight,
      width: AppSizes.currencyPillWidth,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.accentSecondary,
          borderRadius: AppRadius.xl,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Center(
            child: Text(
              currencyCode,
              style: AppTextStyles.body3.copyWith(
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
