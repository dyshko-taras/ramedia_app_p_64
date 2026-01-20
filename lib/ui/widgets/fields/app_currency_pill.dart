import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/app_icons.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_spacing.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class AppCurrencyPill extends StatelessWidget {
  const AppCurrencyPill({
    required this.currencyCode,
    super.key,
    this.onTap,
    this.showChevron = false,
  });

  final String currencyCode;
  final VoidCallback? onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.buttonHeight,
      width: AppSizes.currencyPillWidth,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.xl,
        child: Ink(
          decoration: const BoxDecoration(
            color: AppColors.accentSecondary,
            borderRadius: AppRadius.xl,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    currencyCode,
                    style: AppTextStyles.body3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (showChevron) ...[
                  const SizedBox(width: AppSpacing.md),
                  SizedBox.square(
                    dimension: AppSizes.navIconSize,
                    child: SvgPicture.asset(
                      AppIcons.chevronDown,
                      colorFilter: const ColorFilter.mode(
                        AppColors.textPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
