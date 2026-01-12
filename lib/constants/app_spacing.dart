import 'package:flutter/widgets.dart';

abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 40.0;
}

abstract final class Insets {
  static const allXs = EdgeInsets.all(AppSpacing.xs);
  static const allSm = EdgeInsets.all(AppSpacing.sm);
  static const allMd = EdgeInsets.all(AppSpacing.md);
  static const allLg = EdgeInsets.all(AppSpacing.lg);
  static const allXl = EdgeInsets.all(AppSpacing.xl);

  static const hSm = EdgeInsets.symmetric(horizontal: AppSpacing.sm);
  static const hMd = EdgeInsets.symmetric(horizontal: AppSpacing.md);
  static const hLg = EdgeInsets.symmetric(horizontal: AppSpacing.lg);

  static const vSm = EdgeInsets.symmetric(vertical: AppSpacing.sm);
  static const vMd = EdgeInsets.symmetric(vertical: AppSpacing.md);
  static const vLg = EdgeInsets.symmetric(vertical: AppSpacing.lg);
}

abstract final class Gaps {
  static const hXs = SizedBox(height: AppSpacing.xs);
  static const hSm = SizedBox(height: AppSpacing.sm);
  static const hMd = SizedBox(height: AppSpacing.md);
  static const hLg = SizedBox(height: AppSpacing.lg);
  static const hXl = SizedBox(height: AppSpacing.xl);

  static const wXs = SizedBox(width: AppSpacing.xs);
  static const wSm = SizedBox(width: AppSpacing.sm);
  static const wMd = SizedBox(width: AppSpacing.md);
  static const wLg = SizedBox(width: AppSpacing.lg);
  static const wXl = SizedBox(width: AppSpacing.xl);
}

extension NumSpaceExtension on num {
  SizedBox get h => SizedBox(height: toDouble());
  SizedBox get w => SizedBox(width: toDouble());
}

