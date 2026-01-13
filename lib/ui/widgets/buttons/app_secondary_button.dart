import 'package:flutter/material.dart';

import '../../../constants/app_sizes.dart';
import '../../../constants/app_radius.dart';

class AppSecondaryButton extends StatelessWidget {
  const AppSecondaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.foregroundColor,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius = AppRadius.xl,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.buttonHeight,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: (foregroundColor == null &&
                backgroundColor == null &&
                borderColor == null)
            ? null
            : OutlinedButton.styleFrom(
                foregroundColor: foregroundColor,
                backgroundColor: backgroundColor,
                side: borderColor == null
                    ? null
                    : BorderSide(color: borderColor!, width: borderWidth),
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
