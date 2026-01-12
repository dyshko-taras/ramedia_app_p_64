import 'package:flutter/material.dart';

import '../../../constants/app_sizes.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.buttonHeight,
      width: double.infinity,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
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

