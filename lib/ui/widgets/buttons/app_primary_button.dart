import 'package:flutter/material.dart';

import '../../../constants/app_sizes.dart';
import '../../../constants/app_radius.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius = AppRadius.xl,
    this.height,
    this.width,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderRadius borderRadius;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? AppSizes.buttonHeight,
      width: width ?? double.infinity,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: (backgroundColor == null && foregroundColor == null)
            ? null
            : FilledButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
              ),
        child: isLoading
            ? const SizedBox(
                height: AppSizes.loadingIndicatorSize,
                width: AppSizes.loadingIndicatorSize,
                child: CircularProgressIndicator(
                  strokeWidth: AppSizes.loadingIndicatorStrokeWidth,
                ),
              )
            : Text(label),
      ),
    );
  }
}
