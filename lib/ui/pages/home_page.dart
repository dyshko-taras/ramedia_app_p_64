import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_icons.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_strings.dart';
import '../../data/models/budget_transaction.dart';
import '../../data/models/participant.dart';
import '../../data/repositories/participants_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/repositories/transactions_repository.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons/app_primary_button.dart';
import '../widgets/sheets/add_expenses_sheet.dart';
import '../widgets/sheets/add_income_sheet.dart';
import '../widgets/sheets/add_participant_sheet.dart';
import 'home_cubit.dart';
import 'home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(
        profileRepository: context.read<ProfileRepository>(),
        participantsRepository: context.read<ParticipantsRepository>(),
        transactionsRepository: context.read<TransactionsRepository>(),
        settingsRepository: context.read<SettingsRepository>(),
      )..load(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final profileName = state.profile?.name.isNotEmpty == true
            ? state.profile!.name
            : AppStrings.homeUserNamePlaceholder;

        final totalText = _formatMoney(state.totalCents);

        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(color: AppColors.background2),
                ),
                Expanded(
                  flex: 3,
                  child: Container(color: AppColors.background1),
                ),
              ],
            ),
            SafeArea(
              child: Padding(
                padding: Insets.allLg,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const _AvatarPlaceholder(),
                        Gaps.wMd,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.homeWelcome,
                                style: AppTextStyles.body1.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                profileName,
                                style: AppTextStyles.body3.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Gaps.hLg,
                    Text(
                      totalText,
                      style: AppTextStyles.header2.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Gaps.hMd,
                    Text(
                      AppStrings.homeTotalBudgetLabel,
                      style: AppTextStyles.body3.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Gaps.hMd,
                    _DetailsButton(
                      onPressed: () => Navigator.of(context).pushNamed(
                        AppRoutes.participantsBalance,
                      ),
                    ),
                    Gaps.hMd,
                    Gaps.hMd,
                    _QuickActionsCard(
                      onAddIncome: () => _openAddIncome(context, state),
                      onAddExpenses: () => _openAddExpenses(context, state),
                      onAddParticipant: () => _openAddParticipant(context),
                    ),
                    Gaps.hLg,
                    Expanded(
                      child: _TransactionsSection(
                        participants: state.participants,
                        transactions: state.transactions,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openAddIncome(BuildContext context, HomeState state) async {
    final result = await showAddIncomeSheet(
      context: context,
      participants: state.participants,
    );
    if (result == null) return;

    await context.read<HomeCubit>().addIncome(
      participantId: result.participantId,
      amountCents: result.amountCents,
      scheduledAt: result.scheduledAt,
    );
  }

  Future<void> _openAddExpenses(BuildContext context, HomeState state) async {
    final result = await showAddExpensesSheet(
      context: context,
      participants: state.participants,
      balancesByParticipantId: state.balancesByParticipantId,
    );
    if (result == null) return;

    await context.read<HomeCubit>().addExpense(
      participantId: result.participantId,
      amountCents: result.amountCents,
      scheduledAt: result.scheduledAt,
      isSplit: result.isSplit,
      splitMinorByParticipantIdOverride:
          result.splitMinorByParticipantIdOverride,
      splitWithParticipantId: result.splitWithParticipantId,
      splitPercent: result.splitPercent,
    );
  }

  Future<void> _openAddParticipant(BuildContext context) async {
    final result = await showAddParticipantSheet(
      context: context,
      showClear: false,
    );
    if (result == null) return;

    await context.read<HomeCubit>().addParticipant(
      name: result.name,
      photoPath: result.photoPath,
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.onboardingAddRowIconContainerSize,
      width: AppSizes.onboardingAddRowIconContainerSize,
      decoration: const BoxDecoration(
        color: AppColors.layerPrimary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: SvgPicture.asset(
          AppIcons.userAvatarPlaceholder,
          colorFilter: const ColorFilter.mode(
            AppColors.background2,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

class _DetailsButton extends StatelessWidget {
  const _DetailsButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AppPrimaryButton(
      label: AppStrings.homeDetails,
      onPressed: onPressed,
      width: 160,
      backgroundColor: AppColors.layerPrimary,
      foregroundColor: AppColors.textSecondary,
    );
  }
}

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard({
    required this.onAddIncome,
    required this.onAddExpenses,
    required this.onAddParticipant,
  });

  final VoidCallback onAddIncome;
  final VoidCallback onAddExpenses;
  final VoidCallback onAddParticipant;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.layerPrimary,
        borderRadius: AppRadius.xl,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: Insets.allLg,
        child: Row(
          children: [
            Expanded(
              child: _QuickAction(
                icon: AppIcons.quickAddIncome,
                label: AppStrings.homeQuickAddIncome,
                onTap: onAddIncome,
              ),
            ),
            Expanded(
              child: _QuickAction(
                icon: AppIcons.quickAddExpenses,
                label: AppStrings.homeQuickAddExpenses,
                onTap: onAddExpenses,
              ),
            ),
            Expanded(
              child: _QuickAction(
                icon: AppIcons.userAdd,
                label: AppStrings.homeQuickAddParticipant,
                onTap: onAddParticipant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.lg,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: AppSizes.quickActionIconSize,
              child: SvgPicture.asset(
                icon,
                colorFilter: const ColorFilter.mode(
                  AppColors.iconPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Gaps.hSm,
            Text(
              label,
              style: AppTextStyles.body4.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionsSection extends StatelessWidget {
  const _TransactionsSection({
    required this.participants,
    required this.transactions,
  });

  final List<Participant> participants;
  final List<BudgetTransaction> transactions;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Padding(
          padding: Insets.allLg,
          child: Text(
            AppStrings.homeEmptyState,
            style: AppTextStyles.body3.copyWith(color: AppColors.textGray),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final participantById = {
      for (final p in participants) p.id: p,
    };

    return ListView.separated(
      padding: Insets.allLg,
      itemCount: transactions.length,
      separatorBuilder: (_, __) => Gaps.hSm,
      itemBuilder: (context, index) {
        final tx = transactions[index];
        final participant = participantById[tx.participantId];
        final name = participant?.name ?? '—';
        final dateText = _formatDate(tx.scheduledAt);

        final isIncome = tx.type == TransactionType.income;
        final amountText = isIncome
            ? _formatMoney(tx.amountMinor)
            : '-${_formatMoney(tx.amountMinor)}';
        final amountColor = isIncome
            ? AppColors.accentPrimary
            : AppColors.layerError;

        return InkWell(
          onTap: () => _showEntryActions(context, tx),
          borderRadius: AppRadius.lg,
          child: Ink(
            decoration: const BoxDecoration(
              color: AppColors.layerPrimary,
              borderRadius: AppRadius.lg,
            ),
            child: Padding(
              padding: Insets.allMd,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: AppSizes.avatarRadius,
                    backgroundColor: AppColors.layerSecondary,
                    backgroundImage: (participant?.photoPath == null)
                        ? null
                        : FileImage(File(participant!.photoPath!)),
                    child: (participant?.photoPath == null)
                        ? SvgPicture.asset(
                            AppIcons.userAvatarPlaceholder,
                            width: AppSizes.avatarIconSize,
                            height: AppSizes.avatarIconSize,
                          )
                        : null,
                  ),
                  Gaps.wMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          dateText,
                          style: AppTextStyles.body3.copyWith(
                            color: AppColors.textGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    amountText,
                    style: AppTextStyles.body1.copyWith(color: amountColor),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showEntryActions(
    BuildContext context,
    BudgetTransaction tx,
  ) async {
    final action = await showModalBottomSheet<_EntryAction>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _EntryActionsSheet(),
    );

    switch (action) {
      case _EntryAction.edit:
        // Placeholder: will be wired later.
        return;
      case _EntryAction.delete:
        final confirmed = await _showDeleteEntryDialog(context);
        if (!confirmed) return;
        await context.read<HomeCubit>().deleteTransaction(tx.id);
        return;
      case null:
        return;
    }
  }

  Future<bool> _showDeleteEntryDialog(BuildContext context) async {
    final result = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text(AppStrings.deleteEntryTitle),
        content: const Text(AppStrings.deleteEntryMessage),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.commonClose),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(AppStrings.commonDelete),
          ),
        ],
      ),
    );
    return result ?? false;
  }
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

enum _EntryAction {
  edit,
  delete,
}

class _EntryActionsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: Insets.allLg,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.layerPrimary,
                borderRadius: AppRadius.xl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SheetRow(
                    label: AppStrings.commonEdit,
                    icon: AppIcons.edit,
                    iconColor: AppColors.textSecondary,
                    onTap: () => Navigator.of(context).pop(_EntryAction.edit),
                  ),
                  const Divider(height: 1),
                  _SheetRow(
                    label: AppStrings.commonDelete,
                    icon: AppIcons.delete,
                    iconColor: AppColors.layerError,
                    labelColor: AppColors.layerError,
                    onTap: () => Navigator.of(context).pop(_EntryAction.delete),
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

class _SheetRow extends StatelessWidget {
  const _SheetRow({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.labelColor,
  });

  final String label;
  final String icon;
  final Color iconColor;
  final VoidCallback onTap;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final color = labelColor ?? AppColors.textSecondary;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body3.copyWith(color: color),
              ),
            ),
            SvgPicture.asset(
              icon,
              width: AppSizes.navIconSize,
              height: AppSizes.navIconSize,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
