import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_icons.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_strings.dart';
import '../../data/models/currency.dart';
import '../../data/models/participant.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/participants_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons/app_primary_button.dart';
import '../widgets/buttons/app_secondary_button.dart';
import '../widgets/dialogs/app_confirm_dialog.dart';
import '../widgets/fields/app_dropdown.dart';
import '../widgets/sheets/add_participant_sheet.dart';
import '../widgets/sheets/add_your_name_sheet.dart';
import 'onboarding_step_2_cubit.dart';
import 'onboarding_step_2_state.dart';

class OnboardingStep2Page extends StatefulWidget {
  const OnboardingStep2Page({super.key});

  @override
  State<OnboardingStep2Page> createState() => _OnboardingStep2PageState();
}

class _OnboardingStep2PageState extends State<OnboardingStep2Page> {
  late final OnboardingStep2Cubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = OnboardingStep2Cubit(
      profileRepository: context.read<ProfileRepository>(),
      participantsRepository: context.read<ParticipantsRepository>(),
      settingsRepository: context.read<SettingsRepository>(),
    );
    _cubit.load();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: MultiBlocListener(
        listeners: [
          BlocListener<OnboardingStep2Cubit, OnboardingStep2State>(
            listenWhen: (previous, current) =>
                previous.messageVersion != current.messageVersion &&
                current.message != null,
            listener: (context, state) {
              final message = state.message;
              if (message == null) return;
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(SnackBar(content: Text(message)));
              context.read<OnboardingStep2Cubit>().acknowledgeMessage();
            },
          ),
          BlocListener<OnboardingStep2Cubit, OnboardingStep2State>(
            listenWhen: (previous, current) =>
                previous.nextRoute != current.nextRoute &&
                current.nextRoute != null,
            listener: (context, state) {
              final next = state.nextRoute;
              if (next == null) return;
              Navigator.of(context).pushReplacementNamed(next);
              context.read<OnboardingStep2Cubit>().acknowledgeNavigation();
            },
          ),
        ],
        child: const PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: AppColors.background2,
            body: _OnboardingStep2View(),
          ),
        ),
      ),
    );
  }
}

class _OnboardingStep2View extends StatelessWidget {
  const _OnboardingStep2View();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        final cubit = context.read<OnboardingStep2Cubit>();
        if (cubit.state.isCurrencyDropdownOpen) {
          cubit.toggleCurrencyDropdown();
        }
      },
      behavior: HitTestBehavior.opaque,
      child: ColoredBox(
        color: AppColors.background2,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: Insets.allLg,
            child: BlocBuilder<OnboardingStep2Cubit, OnboardingStep2State>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.onboardingStep2Title,
                      style: AppTextStyles.header1.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Gaps.hMd,
                    Text(
                      AppStrings.onboardingStep2Intro,
                      style: AppTextStyles.body3.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Gaps.hMd,
                    if (state.profile == null)
                      _AddRow(
                        onTap: () => _openProfileSheet(context, state.profile),
                      )
                    else
                      _PersonRow(
                        name: state.profile!.name,
                        photoPath: state.profile!.photoPath,
                        onDelete: null,
                      ),
                    Gaps.hMd,
                    Text(
                      AppStrings.onboardingStep2Hint,
                      style: AppTextStyles.body3.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Gaps.hMd,
                    ...state.participants
                        .map(
                          (p) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.lg,
                            ),
                            child: _PersonRow(
                              name: p.name,
                              photoPath: p.photoPath,
                              onDelete: () => _confirmDelete(context, p),
                            ),
                          ),
                        )
                        .toList(),
                    if (state.canAddParticipant)
                      _AddRow(
                        onTap: () => _openParticipantSheet(context),
                      ),
                    Gaps.hMd,
                    Text(
                      AppStrings.onboardingStep2SelectCurrencyLabel,
                      style: AppTextStyles.body3.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Gaps.hSm,
                    _CurrencyDropdown(
                      value: state.selectedCurrency,
                      onChanged: (currency) => unawaited(
                        context.read<OnboardingStep2Cubit>().selectCurrency(
                          currency,
                        ),
                      ),
                    ),
                    Gaps.hLg,
                    _BottomButtons(
                      canContinue: state.canContinue,
                      isSubmitting: state.isSubmitting,
                      onSkip: context.read<OnboardingStep2Cubit>().skip,
                      onContinue: context
                          .read<OnboardingStep2Cubit>()
                          .continueNext,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openProfileSheet(
    BuildContext context,
    UserProfile? profile,
  ) async {
    final result = await showAddYourNameSheet(
      context: context,
      title: AppStrings.addYourNameTitle,
      nameLabel: AppStrings.addYourNameAddNameLabel,
      nameHint: AppStrings.addYourNameParticipantNamePlaceholder,
      photoLabel: AppStrings.addYourNameAddPhotoLabel,
      saveLabel: AppStrings.commonSave,
      clearLabel: AppStrings.commonClearInformation,
      showClear: true,
      initialName: profile?.name,
      initialPhotoPath: profile?.photoPath,
    );
    if (result == null) return;
    if (result.didClear && result.name.isEmpty && result.photoPath == null)
      return;
    await context.read<OnboardingStep2Cubit>().saveProfile(
      name: result.name,
      photoPath: result.photoPath,
    );
  }

  Future<void> _openParticipantSheet(BuildContext context) async {
    final result = await showAddParticipantSheet(context: context);
    if (result == null) return;
    await context.read<OnboardingStep2Cubit>().addParticipant(
      name: result.name,
      photoPath: result.photoPath,
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    Participant participant,
  ) async {
    final confirmed = await showAppConfirmDialog(
      context: context,
      title: AppStrings.deleteParticipantTitle,
      message: AppStrings.deleteParticipantMessage,
      confirmLabel: AppStrings.commonDelete,
      cancelLabel: AppStrings.commonCancel,
      isDestructive: true,
    );
    if (!confirmed) return;
    await context.read<OnboardingStep2Cubit>().deleteParticipant(
      participant.id,
    );
  }
}

class _AddRow extends StatelessWidget {
  const _AddRow({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: AppSizes.onboardingAddRowIconContainerSize,
            width: AppSizes.onboardingAddRowIconContainerSize,
            decoration: const BoxDecoration(
              color: AppColors.layerPrimary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                AppIcons.userAdd,
                width: AppSizes.navIconSize,
                height: AppSizes.navIconSize,
                colorFilter: const ColorFilter.mode(
                  AppColors.accentPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          Gaps.wMd,
          Text(
            AppStrings.onboardingStep2AddTeamMember,
            style: AppTextStyles.body3.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _PersonRow extends StatelessWidget {
  const _PersonRow({
    required this.name,
    required this.photoPath,
    required this.onDelete,
  });

  final String name;
  final String? photoPath;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final imageFile = photoPath == null ? null : File(photoPath!);
    return Row(
      children: [
        CircleAvatar(
          radius: AppSizes.avatarRadius,
          backgroundColor: AppColors.layerPrimary,
          backgroundImage: imageFile == null ? null : FileImage(imageFile),
          child: imageFile == null
              ? SvgPicture.asset(
                  AppIcons.userAvatarPlaceholder,
                  width: AppSizes.avatarIconSize,
                  height: AppSizes.avatarIconSize,
                )
              : null,
        ),
        Gaps.wMd,
        Expanded(
          child: Text(
            name,
            style: AppTextStyles.body3.copyWith(color: AppColors.textPrimary),
          ),
        ),
        if (onDelete != null)
          IconButton(
            onPressed: onDelete,
            icon: SvgPicture.asset(
              AppIcons.close,
              width: AppSizes.navIconSize,
              height: AppSizes.navIconSize,
              colorFilter: const ColorFilter.mode(
                AppColors.textPrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
      ],
    );
  }
}

class _CurrencyDropdown extends StatelessWidget {
  const _CurrencyDropdown({
    required this.value,
    required this.onChanged,
  });

  final Currency? value;
  final ValueChanged<Currency> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppDropdown<Currency>(
      value: value,
      hintText: AppStrings.onboardingStep2CurrencyPlaceholder,
      entries: [
        for (final c in Currency.values)
          AppDropdownEntry(value: c, label: c.code),
      ],
      isSelected: value != null,
      onChanged: (currency) {
        if (currency == null) return;
        onChanged(currency);
      },
    );
  }
}

class _BottomButtons extends StatelessWidget {
  const _BottomButtons({
    required this.canContinue,
    required this.isSubmitting,
    required this.onSkip,
    required this.onContinue,
  });

  final bool canContinue;
  final bool isSubmitting;
  final Future<void> Function() onSkip;
  final Future<void> Function() onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSecondaryButton(
          label: AppStrings.commonSkip,
          onPressed: isSubmitting ? null : () => onSkip(),
          foregroundColor: AppColors.textPrimary,
          borderColor: AppColors.textPrimary,
          borderWidth: 2,
        ),
        Gaps.hSm,
        AppPrimaryButton(
          label: AppStrings.commonContinue,
          onPressed: (!canContinue || isSubmitting) ? null : () => onContinue(),
          isLoading: isSubmitting,
          backgroundColor: AppColors.layerError,
          foregroundColor: AppColors.textPrimary,
        ),
      ],
    );
  }
}
