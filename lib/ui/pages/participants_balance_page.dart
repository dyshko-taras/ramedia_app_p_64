import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_icons.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_strings.dart';
import '../../data/models/participant.dart';
import '../../data/repositories/participants_repository.dart';
import '../../data/repositories/transactions_repository.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons/app_primary_button.dart';
import '../widgets/sheets/add_participant_sheet.dart';
import 'participants_balance_cubit.dart';
import 'participants_balance_state.dart';

class ParticipantsBalancePage extends StatelessWidget {
  const ParticipantsBalancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ParticipantsBalanceCubit(
        participantsRepository: context.read<ParticipantsRepository>(),
        transactionsRepository: context.read<TransactionsRepository>(),
      )..load(),
      child: const _ParticipantsBalanceView(),
    );
  }
}

class _ParticipantsBalanceView extends StatelessWidget {
  const _ParticipantsBalanceView();

  Future<void> _addParticipant(BuildContext context) async {
    final result = await showAddParticipantSheet(
      context: context,
      showClear: false,
    );
    if (result == null) return;

    await context.read<ParticipantsBalanceCubit>().addParticipant(
      name: result.name,
      photoPath: result.photoPath,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background2,
      body: SafeArea(
        child: Padding(
          padding: Insets.allLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: SvgPicture.asset(
                      AppIcons.back,
                      colorFilter: const ColorFilter.mode(
                        AppColors.textSecondary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      AppStrings.participantsBalanceTitle,
                      style: AppTextStyles.header1.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Gaps.hLg,
              AppPrimaryButton(
                label: AppStrings.participantsBalanceAddParticipant,
                onPressed: () => _addParticipant(context),
                backgroundColor: AppColors.accentSecondary,
                foregroundColor: AppColors.textPrimary,
              ),
              Gaps.hLg,
              Expanded(
                child:
                    BlocBuilder<
                      ParticipantsBalanceCubit,
                      ParticipantsBalanceState
                    >(
                      builder: (context, state) {
                        if (state.isLoading) {
                          return const Center(
                            child: SizedBox(
                              height: AppSizes.loadingIndicatorSize,
                              width: AppSizes.loadingIndicatorSize,
                              child: CircularProgressIndicator(
                                strokeWidth:
                                    AppSizes.loadingIndicatorStrokeWidth,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          );
                        }

                        final participantById = {
                          for (final p in state.participants) p.id: p,
                        };

                        return CustomScrollView(
                          slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final p = state.participants[index];
                                  final balance =
                                      state.balancesByParticipantId[p.id] ?? 0;
                                  return _ParticipantRow(
                                    participant: p,
                                    amountText: _formatMoney(balance),
                                  );
                                },
                                childCount: state.participants.length,
                              ),
                            ),
                            if (state.debts.isEmpty)
                              SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(
                                  child: Text(
                                    AppStrings.participantsBalanceEmptyState,
                                    style: AppTextStyles.body3.copyWith(
                                      color: AppColors.textGray,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            else
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final debt = state.debts[index];
                                    final from =
                                        participantById[debt.fromParticipantId];
                                    final to =
                                        participantById[debt.toParticipantId];
                                    if (from == null || to == null) {
                                      return const SizedBox.shrink();
                                    }
                                    return _DebtCard(
                                      from: from,
                                      to: to,
                                      amountText: _formatMoney(
                                        debt.amountMinor,
                                      ),
                                    );
                                  },
                                  childCount: state.debts.length,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ParticipantRow extends StatelessWidget {
  const _ParticipantRow({
    required this.participant,
    required this.amountText,
  });

  final Participant participant;
  final String amountText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Insets.vSm,
      child: Row(
        children: [
          _ParticipantAvatar(participant: participant),
          Gaps.wMd,
          Expanded(
            child: Text(
              participant.name,
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Gaps.wMd,
          Text(
            amountText,
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ParticipantAvatar extends StatelessWidget {
  const _ParticipantAvatar({required this.participant});

  final Participant participant;

  @override
  Widget build(BuildContext context) {
    final imageFile = participant.photoPath == null
        ? null
        : File(participant.photoPath!);

    return ClipOval(
      child: SizedBox(
        height: AppSizes.onboardingAddRowIconContainerSize,
        width: AppSizes.onboardingAddRowIconContainerSize,
        child: imageFile == null
            ? DecoratedBox(
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
              )
            : Image.file(
                imageFile,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

class _DebtCard extends StatelessWidget {
  const _DebtCard({
    required this.from,
    required this.to,
    required this.amountText,
  });

  final Participant from;
  final Participant to;
  final String amountText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Insets.vSm,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.layerPrimary,
          borderRadius: AppRadius.md,
        ),
        child: Padding(
          padding: Insets.allLg,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      from.name,
                      style: AppTextStyles.body3.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      AppStrings.participantsBalanceOwes,
                      style: AppTextStyles.body3.copyWith(
                        color: AppColors.textGray,
                      ),
                    ),
                    Text(
                      to.name,
                      style: AppTextStyles.body3.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Gaps.wMd,
              Text(
                amountText,
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.layerError,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
