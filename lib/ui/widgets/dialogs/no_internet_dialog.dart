import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/app_icons.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_strings.dart';
import '../../../utils/internet_checker.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../buttons/app_primary_button.dart';

Future<void> showNoInternetDialog({
  required BuildContext context,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (_) => const NoInternetDialog(),
  );
}

class NoInternetDialog extends StatefulWidget {
  const NoInternetDialog({super.key});

  @override
  State<NoInternetDialog> createState() => _NoInternetDialogState();
}

class _NoInternetDialogState extends State<NoInternetDialog> {
  var _isChecking = false;

  Future<void> _check() async {
    if (_isChecking) return;
    setState(() => _isChecking = true);

    final hasInternet = await hasInternetConnection();
    if (!mounted) return;

    setState(() => _isChecking = false);
    if (hasInternet) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: Insets.hLg,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.layerPrimary,
              borderRadius: AppRadius.xl,
            ),
            child: Padding(
              padding: Insets.allXl,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    AppIcons.noInternet,
                    colorFilter: const ColorFilter.mode(
                      AppColors.layerError,
                      BlendMode.srcIn,
                    ),
                  ),
                  Gaps.hMd,
                  Text(
                    AppStrings.noInternetTitle,
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 26,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Gaps.hSm,
                  Text(
                    AppStrings.noInternetSubtitle,
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Gaps.hLg,
                  AppPrimaryButton(
                    label: AppStrings.noInternetCheckConnection,
                    onPressed: _isChecking ? null : _check,
                    backgroundColor: AppColors.accentSecondary,
                    foregroundColor: AppColors.textPrimary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
