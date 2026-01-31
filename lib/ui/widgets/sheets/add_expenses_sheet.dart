import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/app_icons.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_strings.dart';
import '../../../data/models/participant.dart';
import '../../../data/repositories/participants_repository.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../buttons/app_primary_button.dart';
import '../fields/app_currency_pill.dart';
import '../fields/app_text_field.dart';
import 'add_participant_sheet.dart';

class AddExpensesResult {
  AddExpensesResult({
    required this.participantId,
    required this.amountCents,
    required this.scheduledAt,
    required this.isSplit,
    this.splitMinorByParticipantIdOverride,
    this.splitWithParticipantId,
    this.splitPercent,
  });

  final String participantId;
  final int amountCents;
  final DateTime scheduledAt;
  final bool isSplit;
  final Map<String, int>? splitMinorByParticipantIdOverride;
  final String? splitWithParticipantId;
  final int? splitPercent;
}

Future<AddExpensesResult?> showAddExpensesSheet({
  required BuildContext context,
  required List<Participant> participants,
  required Map<String, int> balancesByParticipantId,
}) {
  return showModalBottomSheet<AddExpensesResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.layerSecondary,
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheetTop),
    clipBehavior: Clip.antiAlias,
    builder: (_) => _AddExpensesSheet(
      participants: participants,
      balancesByParticipantId: balancesByParticipantId,
    ),
  );
}

class _AddExpensesSheet extends StatefulWidget {
  const _AddExpensesSheet({
    required this.participants,
    required this.balancesByParticipantId,
  });

  final List<Participant> participants;
  final Map<String, int> balancesByParticipantId;

  @override
  State<_AddExpensesSheet> createState() => _AddExpensesSheetState();
}

class _AddExpensesSheetState extends State<_AddExpensesSheet> {
  final _amountController = TextEditingController();

  List<Participant> _participants = const [];
  String? _selectedParticipantId;
  DateTime _scheduledAt = DateTime.now();
  bool _isSplit = false;
  final Map<String, TextEditingController> _splitPercentControllersById = {};
  String? _borrowFromParticipantId;
  late final String _currencyCode;

  @override
  void initState() {
    super.initState();
    _participants = widget.participants;
    _currencyCode =
        context.read<SettingsRepository>().getSelectedCurrencyCode() ?? 'USD';
    unawaited(_refreshParticipants());
  }

  @override
  void dispose() {
    _amountController.dispose();
    for (final c in _splitPercentControllersById.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final cents = _parseCents(_amountController.text);

    final selectedParticipantId = _selectedParticipantId;
    final selectedBalanceCents = selectedParticipantId == null
        ? 0
        : (widget.balancesByParticipantId[selectedParticipantId] ?? 0);

    final payerContribution = selectedBalanceCents.clamp(0, cents).toInt();
    final missingCents = cents - payerContribution;

    final eligibleBorrowers = selectedParticipantId == null || missingCents <= 0
        ? const <Participant>[]
        : _participants
              .where(
                (p) =>
                    p.id != selectedParticipantId &&
                    (widget.balancesByParticipantId[p.id] ?? 0) >= missingCents,
              )
              .toList();

    final isBorrowFlow =
        !_isSplit &&
        selectedParticipantId != null &&
        cents > 0 &&
        cents > selectedBalanceCents;

    final canSaveBase = _selectedParticipantId != null && cents > 0;
    final splitPlan = _computeSplitPlan(
      payerId: selectedParticipantId,
      amountCents: cents,
    );
    final canSaveSplit = !_isSplit || splitPlan != null;
    final canSaveBorrow =
        !isBorrowFlow ||
        (eligibleBorrowers.isNotEmpty &&
            _borrowFromParticipantId != null &&
            eligibleBorrowers.any((p) => p.id == _borrowFromParticipantId));
    final canSave = canSaveBase && canSaveSplit && canSaveBorrow;

    final splitCandidates = selectedParticipantId == null
        ? _participants
        : _participants.where((p) => p.id != selectedParticipantId).toList();
    final participantById = {
      for (final p in _participants) p.id: p,
    };
    final splitOtherPercentTotalRaw = _splitPercentControllersById.values.fold(
      0,
      (sum, c) => sum + (int.tryParse(c.text.trim()) ?? 0).clamp(0, 100),
    );
    final splitIsOver100 = splitOtherPercentTotalRaw > 100;
    final splitPayerPercentRaw = (100 - splitOtherPercentTotalRaw).clamp(
      0,
      100,
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: ColoredBox(
        color: AppColors.layerSecondary,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: Insets.allLg,
                    child: Row(
                      children: [
                        const Spacer(),
                        Text(
                          AppStrings.addExpensesTitle,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: Insets.allLg,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppStrings.addExpensesWhoIsSpending,
                            style: AppTextStyles.body1.copyWith(
                              color: AppColors.textGray,
                            ),
                          ),
                        ),
                        Gaps.hMd,
                        if (_participants.isEmpty)
                          SizedBox(
                            width: double.infinity,
                            child: AppPrimaryButton(
                              label: AppStrings.addExpensesAddParticipant,
                              onPressed: _addParticipant,
                              backgroundColor: AppColors.accentSecondary,
                              foregroundColor: AppColors.textPrimary,
                            ),
                          )
                        else
                          SizedBox(
                            height: AppSizes.buttonHeight,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _participants.length,
                              separatorBuilder: (_, __) => const SizedBox(
                                width: AppSpacing.md,
                              ),
                              itemBuilder: (context, index) {
                                final p = _participants[index];
                                return _ChoicePill(
                                  label: p.name,
                                  isSelected: _selectedParticipantId == p.id,
                                  onTap: () => setState(
                                    () => _selectedParticipantId = p.id,
                                  ),
                                );
                              },
                            ),
                          ),
                        Gaps.hLg,
                        Row(
                          children: [
                            Expanded(
                              child: AppTextField(
                                controller: _amountController,
                                hintText:
                                    AppStrings.addExpensesAmountPlaceholder,
                                keyboardType: TextInputType.number,
                                textStyle: isBorrowFlow
                                    ? AppTextStyles.input.copyWith(
                                        color: AppColors.layerError,
                                      )
                                    : null,
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                            Gaps.wMd,
                            AppCurrencyPill(currencyCode: _currencyCode),
                          ],
                        ),
                        if (isBorrowFlow) ...[
                          Gaps.hSm,
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppStrings.transactionExceedsBalance.replaceFirst(
                                '{amount}',
                                _formatMoney(missingCents),
                              ),
                              style: AppTextStyles.body3.copyWith(
                                color: AppColors.layerError,
                              ),
                            ),
                          ),
                          Gaps.hSm,
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppStrings.transactionBorrowMissingAmount,
                              style: AppTextStyles.body1.copyWith(
                                color: AppColors.textGray,
                              ),
                            ),
                          ),
                          Gaps.hMd,
                          if (eligibleBorrowers.isNotEmpty)
                            SizedBox(
                              height: AppSizes.buttonHeight,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: eligibleBorrowers.length,
                                separatorBuilder: (_, __) => const SizedBox(
                                  width: AppSpacing.md,
                                ),
                                itemBuilder: (context, index) {
                                  final p = eligibleBorrowers[index];
                                  return _ChoicePill(
                                    label: p.name,
                                    isSelected:
                                        _borrowFromParticipantId == p.id,
                                    onTap: () => setState(
                                      () => _borrowFromParticipantId = p.id,
                                    ),
                                  );
                                },
                              ),
                            )
                          else
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppStrings.enterDifferentAmountMessage,
                                style: AppTextStyles.body3.copyWith(
                                  color: AppColors.layerError,
                                ),
                              ),
                            ),
                        ],
                        if (!isBorrowFlow) ...[
                          Gaps.hLg,
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppStrings.addExpensesSplitTransactionLabel,
                              style: AppTextStyles.body1.copyWith(
                                color: AppColors.textGray,
                              ),
                            ),
                          ),
                          Gaps.hMd,
                          Row(
                            children: [
                              _RadioChoice(
                                label: AppStrings.commonYes,
                                isSelected: _isSplit,
                                onTap: () => setState(() {
                                  _isSplit = true;
                                  _borrowFromParticipantId = null;
                                }),
                              ),
                              Gaps.wXl,
                              _RadioChoice(
                                label: AppStrings.commonNo,
                                isSelected: !_isSplit,
                                onTap: () => setState(() {
                                  _isSplit = false;
                                  for (final c
                                      in _splitPercentControllersById.values) {
                                    c.dispose();
                                  }
                                  _splitPercentControllersById.clear();
                                }),
                              ),
                            ],
                          ),
                          if (_isSplit) ...[
                            Gaps.hLg,
                            if (splitCandidates.isNotEmpty)
                              SizedBox(
                                height: AppSizes.buttonHeight,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: splitCandidates.length,
                                  separatorBuilder: (_, __) => const SizedBox(
                                    width: AppSpacing.md,
                                  ),
                                  itemBuilder: (context, index) {
                                    final p = splitCandidates[index];
                                    final isSelected =
                                        _splitPercentControllersById
                                            .containsKey(p.id);
                                    return _ChoicePill(
                                      label: p.name,
                                      isSelected: isSelected,
                                      onTap: () => setState(() {
                                        if (isSelected) {
                                          _splitPercentControllersById
                                              .remove(p.id)
                                              ?.dispose();
                                          return;
                                        }
                                        _splitPercentControllersById[p.id] =
                                            TextEditingController();
                                      }),
                                    );
                                  },
                                ),
                              ),
                            if (_splitPercentControllersById.isNotEmpty) ...[
                              Gaps.hMd,
                              for (final entry
                                  in _splitPercentControllersById.entries) ...[
                                _SplitRow(
                                  participantName:
                                      participantById[entry.key]?.name ?? '—',
                                  controller: entry.value,
                                  onChanged: () => setState(() {}),
                                ),
                                Gaps.hSm,
                              ],
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  AppStrings.addExpensesRemainingPercent
                                      .replaceFirst(
                                        '{percent}',
                                        (100 - splitOtherPercentTotalRaw)
                                            .toString(),
                                      ),
                                  style: AppTextStyles.body3.copyWith(
                                    color: splitIsOver100
                                        ? AppColors.layerError
                                        : AppColors.textGray,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  AppStrings.addExpensesPayerPercent
                                      .replaceFirst(
                                        '{percent}',
                                        splitPayerPercentRaw.toString(),
                                      ),
                                  style: AppTextStyles.body3.copyWith(
                                    color: splitIsOver100
                                        ? AppColors.layerError
                                        : AppColors.textGray,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ],
                        Gaps.hLg,
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppStrings.addExpensesPaymentScheduleLabel,
                            style: AppTextStyles.body1.copyWith(
                              color: AppColors.textGray,
                            ),
                          ),
                        ),
                        Gaps.hSm,
                        _DateField(
                          label: _formatDate(_scheduledAt),
                          onTap: () => unawaited(_pickDate()),
                        ),
                        Gaps.hXl,
                        AppPrimaryButton(
                          label: AppStrings.commonSave,
                          onPressed: canSave ? _onSave : null,
                          backgroundColor: AppColors.accentPrimary,
                          foregroundColor: AppColors.textPrimary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshParticipants() async {
    final participants = await context.read<ParticipantsRepository>().getAll();
    if (!mounted) return;
    setState(() {
      _participants = participants;
      _selectedParticipantId ??= participants.isEmpty
          ? null
          : participants.first.id;
    });
  }

  Future<void> _addParticipant() async {
    final result = await showAddParticipantSheet(
      context: context,
      showClear: false,
    );
    if (result == null) return;

    final participant = Participant(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: result.name,
      photoPath: result.photoPath,
      createdAt: DateTime.now(),
    );

    await context.read<ParticipantsRepository>().upsert(participant);
    await _refreshParticipants();
    if (!mounted) return;
    setState(() => _selectedParticipantId ??= participant.id);
  }

  void _onSave() {
    final participantId = _selectedParticipantId;
    if (participantId == null) return;
    final cents = _parseCents(_amountController.text);
    if (cents <= 0) return;

    final balanceCents = widget.balancesByParticipantId[participantId] ?? 0;
    final isBorrowFlow = !_isSplit && cents > balanceCents;
    if (isBorrowFlow) {
      final payerContribution = balanceCents.clamp(0, cents).toInt();
      final missingCents = cents - payerContribution;
      final eligibleBorrowers = widget.participants
          .where(
            (p) =>
                p.id != participantId &&
                (widget.balancesByParticipantId[p.id] ?? 0) >= missingCents,
          )
          .toList();

      if (eligibleBorrowers.isEmpty) {
        unawaited(_showEnterDifferentAmountDialog());
        return;
      }

      final borrowerId = _borrowFromParticipantId;
      if (borrowerId == null ||
          !eligibleBorrowers.any((p) => p.id == borrowerId)) {
        return;
      }

      Navigator.of(context).pop(
        AddExpensesResult(
          participantId: participantId,
          amountCents: cents,
          scheduledAt: _scheduledAt,
          isSplit: false,
          splitMinorByParticipantIdOverride: <String, int>{
            participantId: payerContribution,
            borrowerId: missingCents,
          },
        ),
      );
      return;
    }

    if (_isSplit) {
      final plan = _computeSplitPlan(
        payerId: participantId,
        amountCents: cents,
      );
      if (plan == null) return;

      Navigator.of(context).pop(
        AddExpensesResult(
          participantId: participantId,
          amountCents: cents,
          scheduledAt: _scheduledAt,
          isSplit: true,
          splitMinorByParticipantIdOverride: plan.sharesByParticipantId,
          splitWithParticipantId: null,
          splitPercent: null,
        ),
      );
      return;
    }

    Navigator.of(context).pop(
      AddExpensesResult(
        participantId: participantId,
        amountCents: cents,
        scheduledAt: _scheduledAt,
        isSplit: _isSplit,
        splitMinorByParticipantIdOverride: null,
        splitWithParticipantId: null,
        splitPercent: null,
      ),
    );
  }

  _SplitPlan? _computeSplitPlan({
    required String? payerId,
    required int amountCents,
  }) {
    if (!_isSplit) return null;
    if (payerId == null) return null;
    if (amountCents <= 0) return null;
    if (_splitPercentControllersById.isEmpty) return null;

    final percentsById = <String, int>{};
    var othersPercentTotal = 0;
    for (final entry in _splitPercentControllersById.entries) {
      final raw = entry.value.text.trim();
      if (raw.isEmpty) return null;
      final value = int.tryParse(raw);
      if (value == null) return null;
      if (value <= 0 || value > 100) return null;
      othersPercentTotal += value;
      if (othersPercentTotal > 100) return null;
      percentsById[entry.key] = value;
    }

    final payerPercent = 100 - othersPercentTotal;
    if (payerPercent < 0) return null;

    final sharesByParticipantId = <String, int>{};
    var othersSumMinor = 0;
    for (final entry in percentsById.entries) {
      final share = ((amountCents * entry.value) / 100).round();
      sharesByParticipantId[entry.key] = share;
      othersSumMinor += share;
    }

    final payerShare = amountCents - othersSumMinor;
    if (payerShare < 0) return null;
    sharesByParticipantId[payerId] = payerShare;

    return _SplitPlan(
      payerPercent: payerPercent,
      othersPercentTotal: othersPercentTotal,
      sharesByParticipantId: sharesByParticipantId,
    );
  }

  Future<void> _showEnterDifferentAmountDialog() {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.enterDifferentAmountTitle),
        content: const Text(AppStrings.enterDifferentAmountMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.commonClose),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
      initialDate: _scheduledAt,
    );
    if (picked == null) return;
    setState(() => _scheduledAt = picked);
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.accentSecondary : AppColors.layerPrimary,
      borderRadius: AppRadius.xl,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.xl,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          child: Text(
            label,
            style: AppTextStyles.body3.copyWith(
              color: isSelected
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _RadioChoice extends StatelessWidget {
  const _RadioChoice({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.lg,
      child: Padding(
        padding: Insets.allSm,
        child: Row(
          children: [
            _RadioIcon(isSelected: isSelected),
            Gaps.wSm,
            Text(
              label,
              style: AppTextStyles.body3.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioIcon extends StatelessWidget {
  const _RadioIcon({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? AppColors.accentPrimary
        : AppColors.textSecondary;
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: AppColors.accentPrimary,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.layerPrimary,
        borderRadius: AppRadius.xl,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        child: Text(
          label,
          style: AppTextStyles.body3.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

class _SplitRow extends StatelessWidget {
  const _SplitRow({
    required this.participantName,
    required this.controller,
    required this.onChanged,
  });

  final String participantName;
  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _InfoPill(label: participantName)),
        Gaps.wMd,
        SizedBox(
          width: 140,
          child: AppTextField(
            controller: controller,
            hintText: AppStrings.addExpensesEnterPercentagePlaceholder,
            keyboardType: TextInputType.number,
            onChanged: (_) => onChanged(),
            suffixIcon: Center(
              widthFactor: 1,
              child: Text(
                '%',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SplitPlan {
  const _SplitPlan({
    required this.payerPercent,
    required this.othersPercentTotal,
    required this.sharesByParticipantId,
  });

  final int payerPercent;
  final int othersPercentTotal;
  final Map<String, int> sharesByParticipantId;
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSizes.buttonHeight,
        padding: Insets.hLg,
        decoration: BoxDecoration(
          color: AppColors.layerSecondary,
          borderRadius: AppRadius.xl,
          border: Border.all(color: AppColors.accentPrimary, width: 2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body3.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Container(
              // height: AppSizes.buttonHeight,
              width: AppSizes.buttonHeight,
              padding: Insets.allLg,
              decoration: const BoxDecoration(
                color: AppColors.accentPrimary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppIcons.calendar,
                  width: AppSizes.navIconSize,
                  height: AppSizes.navIconSize,
                  colorFilter: const ColorFilter.mode(
                    AppColors.iconPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

int _parseCents(String text) {
  final cleaned = text.trim().replaceAll(',', '.');
  if (cleaned.isEmpty) return 0;
  final value = double.tryParse(cleaned);
  if (value == null) return 0;
  return (value * 100).round();
}

String _formatMoney(int cents) {
  final abs = cents.abs();
  final whole = abs ~/ 100;
  final frac = abs % 100;
  final sign = cents < 0 ? '-' : '';
  if (frac == 0) return '$sign\$$whole';
  final two = frac.toString().padLeft(2, '0');
  return '$sign\$$whole.$two';
}

String _formatDate(DateTime date) {
  final dd = date.day.toString().padLeft(2, '0');
  final mm = date.month.toString().padLeft(2, '0');
  final yyyy = date.year.toString();
  return '$dd.$mm.$yyyy';
}
