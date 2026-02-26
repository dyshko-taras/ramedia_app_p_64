import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_radius.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons/app_primary_button.dart';
import 'credit_cubit.dart';
import 'credit_state.dart';

class CreditPage extends StatelessWidget {
  const CreditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreditCubit(),
      child: const _CreditView(),
    );
  }
}

class _CreditView extends StatelessWidget {
  const _CreditView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreditCubit, CreditState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background2,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: Insets.allLg,
                  child: Center(
                    child: Text(
                      AppStrings.creditCalculatorTitle,
                      style: AppTextStyles.header1.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: Insets.hLg,
                  child: _SummaryCard(
                    creditAmountText: _formatUsdAmount(state.loanAmount),
                    interestText: state.hasCalculated
                        ? _formatUsdWithCode(state.interestAmount)
                        : _formatUsdWithCode(0),
                    repaymentText: state.hasCalculated
                        ? _formatUsdWithCode(state.repaymentAmount)
                        : _formatUsdWithCode(0),
                  ),
                ),
                Gaps.hLg,
                Expanded(
                  child: ColoredBox(
                    color: AppColors.background1,
                    child: SingleChildScrollView(
                      padding: Insets.allLg,
                      child: Column(
                        children: [
                          _SliderSection(
                            title: AppStrings.creditCalculatorLoanAmountLabel,
                            valueText: _formatUsdAmount(state.loanAmount),
                            minLabel: '100 USD',
                            maxLabel: '100 000 USD',
                            slider: _ThemedSlider(
                              value: state.loanAmount.clamp(0, 100000),
                              min: 0,
                              max: 100000,
                              divisions: 1000,
                              onChanged: (v) =>
                                  context.read<CreditCubit>().setLoanAmount(v),
                            ),
                          ),
                          Gaps.hLg,
                          _SliderSection(
                            title: AppStrings.creditCalculatorLoanTermLabel,
                            valueText: state.loanTermMonths.toString(),
                            minLabel: '1',
                            maxLabel: '24',
                            slider: _ThemedSlider(
                              value: state.loanTermMonths.toDouble().clamp(
                                0,
                                24,
                              ),
                              min: 0,
                              max: 24,
                              divisions: 24,
                              onChanged: (v) => context
                                  .read<CreditCubit>()
                                  .setLoanTermMonths(v.round()),
                            ),
                          ),
                          Gaps.hLg,
                          _SliderSection(
                            title: AppStrings.creditCalculatorInterestRateLabel,
                            valueText: _formatPercent(
                              state.interestRatePercent,
                            ),
                            minLabel: '0%',
                            maxLabel: '10%',
                            slider: _ThemedSlider(
                              value: state.interestRatePercent.clamp(0, 10),
                              min: 0,
                              max: 10,
                              divisions: 100,
                              onChanged: (v) => context
                                  .read<CreditCubit>()
                                  .setInterestRatePercent(v),
                            ),
                          ),
                          Gaps.hXl,
                          AppPrimaryButton(
                            label: AppStrings.creditCalculatorCalculate,
                            onPressed: state.canCalculate
                                ? () => context.read<CreditCubit>().calculate()
                                : null,
                            backgroundColor: AppColors.accentSecondary,
                            foregroundColor: AppColors.textPrimary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.creditAmountText,
    required this.interestText,
    required this.repaymentText,
  });

  final String creditAmountText;
  final String interestText;
  final String repaymentText;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.layerPrimary,
        borderRadius: AppRadius.xl,
      ),
      child: Padding(
        padding: Insets.allXl,
        child: Column(
          children: [
            Text(
              creditAmountText,
              style: AppTextStyles.header2.copyWith(
                color: AppColors.textSecondary,
                height: 0.8,
              ),
            ),
            Gaps.hSm,
            Text(
              AppStrings.creditCalculatorCreditAmountLabel,
              style: AppTextStyles.body3.copyWith(color: AppColors.textGray),
            ),
            Gaps.hXl,
            _SummaryRow(
              label: AppStrings.creditCalculatorInterestLabel,
              value: interestText,
            ),
            Gaps.hLg,
            _SummaryRow(
              label: AppStrings.creditCalculatorRepaymentAmountLabel,
              value: repaymentText,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.body1.copyWith(color: AppColors.textGray),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _SliderSection extends StatelessWidget {
  const _SliderSection({
    required this.title,
    required this.valueText,
    required this.minLabel,
    required this.maxLabel,
    required this.slider,
  });

  final String title;
  final String valueText;
  final String minLabel;
  final String maxLabel;
  final Widget slider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Text(
              valueText,
              style: AppTextStyles.header1.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Gaps.hSm,
        slider,
        Padding(
          padding: Insets.hMd,
          child: Row(
            children: [
              Text(
                minLabel,
                style: AppTextStyles.body3.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                maxLabel,
                style: AppTextStyles.body3.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ThemedSlider extends StatelessWidget {
  const _ThemedSlider({
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 8,
        activeTrackColor: AppColors.accentSecondary,
        inactiveTrackColor: AppColors.layerSecondary,
        thumbColor: AppColors.accentPrimary,
        overlayColor: AppColors.accentPrimary.withValues(alpha: 0.15),
        thumbShape: const _RingThumbShape(),
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        onChanged: onChanged,
      ),
    );
  }
}

class _RingThumbShape extends SliderComponentShape {
  const _RingThumbShape();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(28, 28);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(center.translate(0, 2), 14, shadowPaint);

    final outerPaint = Paint()..color = AppColors.accentPrimary;
    canvas.drawCircle(center, 14, outerPaint);

    final innerPaint = Paint()..color = AppColors.layerPrimary;
    canvas.drawCircle(center, 9, innerPaint);
  }
}

String _formatPercent(double value) {
  final fixed = value.toStringAsFixed(1);
  final cleaned = fixed.endsWith('.0')
      ? fixed.substring(0, fixed.length - 2)
      : fixed;
  return '$cleaned%';
}

String _formatUsdWithCode(double amount) => '${_formatNumber(amount)} USD';

String _formatUsdAmount(double amount) => '\$${_formatNumber(amount)}';

String _formatNumber(double value) {
  final rounded2 = (value * 100).round() / 100;
  final isInt = (rounded2 - rounded2.truncateToDouble()).abs() < 0.001;
  final intPart = isInt
      ? rounded2.toInt().toString()
      : rounded2.floor().toString();
  final grouped = _groupSpaces(intPart);

  if (isInt) return grouped;
  final frac = ((rounded2 - rounded2.floor()) * 100).round().toString().padLeft(
    2,
    '0',
  );
  return '$grouped.$frac';
}

String _groupSpaces(String digits) {
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final left = digits.length - i;
    buffer.write(digits[i]);
    if (left > 1 && left % 3 == 1) {
      buffer.write(' ');
    }
  }
  return buffer.toString();
}
