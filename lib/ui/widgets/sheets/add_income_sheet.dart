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
import '../sheets/add_participant_sheet.dart';

class AddIncomeResult {
  AddIncomeResult({
    required this.participantId,
    required this.amountCents,
    required this.scheduledAt,
  });

  final String participantId;
  final int amountCents;
  final DateTime scheduledAt;
}

Future<AddIncomeResult?> showAddIncomeSheet({
  required BuildContext context,
  required List<Participant> participants,
}) {
  return showModalBottomSheet<AddIncomeResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.layerSecondary,
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheetTop),
    clipBehavior: Clip.antiAlias,
    builder: (_) => _AddIncomeSheet(participants: participants),
  );
}

class _AddIncomeSheet extends StatefulWidget {
  const _AddIncomeSheet({
    required this.participants,
  });

  final List<Participant> participants;

  @override
  State<_AddIncomeSheet> createState() => _AddIncomeSheetState();
}

class _AddIncomeSheetState extends State<_AddIncomeSheet> {
  final _amountController = TextEditingController();

  List<Participant> _participants = const [];
  String? _selectedParticipantId;
  DateTime _scheduledAt = DateTime.now();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final canSave =
        _selectedParticipantId != null &&
        _parseCents(_amountController.text) > 0;

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
                          AppStrings.addIncomeTitle,
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
                            AppStrings.addIncomeWhoIsToppingUp,
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
                              label: AppStrings.addIncomeAddParticipant,
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
                                hintText: AppStrings.addIncomeAmountPlaceholder,
                                keyboardType: TextInputType.number,
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                            Gaps.wMd,
                            AppCurrencyPill(currencyCode: _currencyCode),
                          ],
                        ),
                        Gaps.hLg,
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppStrings.addIncomePaymentScheduleLabel,
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
    Navigator.of(context).pop(
      AddIncomeResult(
        participantId: participantId,
        amountCents: cents,
        scheduledAt: _scheduledAt,
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
              height: AppSizes.buttonHeight,
              width: AppSizes.buttonHeight,
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

String _formatDate(DateTime date) {
  final dd = date.day.toString().padLeft(2, '0');
  final mm = date.month.toString().padLeft(2, '0');
  final yyyy = date.year.toString();
  return '$dd.$mm.$yyyy';
}
