import 'package:flutter/material.dart';

import '../../../constants/app_radius.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_spacing.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class AppDropdownEntry<T> {
  const AppDropdownEntry({
    required this.value,
    required this.label,
  });

  final T value;
  final String label;
}

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    required this.entries,
    required this.onChanged,
    super.key,
    this.value,
    this.hintText,
    this.width = AppSizes.currencyDropdownWidth,
    this.height = AppSizes.buttonHeight,
    this.isSelected = false,
    this.selectedBackgroundColor = AppColors.accentSecondary,
    this.unselectedBackgroundColor = AppColors.accentSecondary,
  });

  final List<AppDropdownEntry<T>> entries;
  final ValueChanged<T?> onChanged;
  final T? value;
  final String? hintText;

  final double width;
  final double height;
  final bool isSelected;

  final Color selectedBackgroundColor;
  final Color unselectedBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = unselectedBackgroundColor;
    final textColor = AppColors.textSecondary;

    final items = entries
        .map(
          (e) => DropdownMenuItem<T>(
            value: e.value,
            child: Text(
              e.label,
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        )
        .toList();

    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: AppRadius.lg,
        ),
        child: Padding(
          padding: Insets.hMd,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              borderRadius: AppRadius.lg,
              icon: const Icon(Icons.keyboard_arrow_down),
              dropdownColor: AppColors.layerPrimary,
              style: AppTextStyles.body1.copyWith(color: textColor),
              selectedItemBuilder: (context) => entries
                  .map(
                    (e) => Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        e.label,
                        style: AppTextStyles.body1.copyWith(color: textColor),
                      ),
                    ),
                  )
                  .toList(),
              hint: hintText == null
                  ? null
                  : Text(
                      hintText!,
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }
}
