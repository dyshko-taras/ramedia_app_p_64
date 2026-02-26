import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants/app_icons.dart';
import '../../constants/app_links.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_strings.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/participants_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../settings_actions.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/sheets/add_your_name_sheet.dart';
import 'settings_cubit.dart';
import 'settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(
        profileRepository: context.read<ProfileRepository>(),
        participantsRepository: context.read<ParticipantsRepository>(),
        settingsRepository: context.read<SettingsRepository>(),
      )..load(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  Future<void> _editProfile(BuildContext context, UserProfile? profile) async {
    final result = await showAddYourNameSheet(
      context: context,
      title: AppStrings.addYourNameTitle,
      nameLabel: AppStrings.addYourNameAddNameLabel,
      nameHint: AppStrings.addYourNameParticipantNamePlaceholder,
      photoLabel: AppStrings.addYourNameAddPhotoLabel,
      saveLabel: AppStrings.commonSave,
      clearLabel: AppStrings.commonClearInformation,
      showClear: false,
      initialName: profile?.name,
      initialPhotoPath: profile?.photoPath,
    );
    if (result == null) return;
    await context.read<SettingsCubit>().upsertProfile(
      name: result.name,
      photoPath: result.photoPath,
    );
  }

  Future<void> _handleNotificationsTap(BuildContext context) async {
    final cubit = context.read<SettingsCubit>();
    final requested = cubit.getPushPermissionRequested();

    if (!requested) {
      await cubit.setPushPermissionRequested(true);
      final status = await Permission.notification.request();
      if (status.isGranted) return;
    }

    await openAppSettings();
  }

  Future<void> _handleClearData(BuildContext context) async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text(AppStrings.clearDataTitle),
        content: const Text(AppStrings.clearDataMessage),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(AppStrings.commonAccept),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.commonCancel),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await context.read<SettingsCubit>().clearAllData();
    if (!context.mounted) return;
    await Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.onboardingStep1,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background1,
      body: SafeArea(
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final profile = state.profile;

            return Padding(
              padding: Insets.allLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      AppStrings.settingsTitle,
                      style: AppTextStyles.header1.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Gaps.hXl,
                  _ProfileRow(
                    profile: profile,
                    onEdit: () => _editProfile(context, profile),
                  ),
                  Gaps.hXl,
                  _SettingsItem(
                    label: AppStrings.settingsNotifications,
                    onTap: () => _handleNotificationsTap(context),
                  ),
                  Gaps.hMd,
                  _SettingsItem(
                    label: AppStrings.settingsPrivacyPolicy,
                    onTap: () => openPrivacyPolicy(AppLinks.privacyPolicy),
                  ),
                  Gaps.hMd,
                  _SettingsItem(
                    label: AppStrings.settingsShareApplication,
                    onTap: () => shareApplication(AppLinks.appShare),
                  ),
                  Gaps.hMd,
                  _SettingsItem(
                    label: AppStrings.settingsClearData,
                    onTap: () => _handleClearData(context),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.profile,
    required this.onEdit,
  });

  final UserProfile? profile;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final name = (profile?.name.trim().isNotEmpty ?? false)
        ? profile!.name
        : AppStrings.settingsUserNamePlaceholder;

    final sinceText = profile == null
        ? ''
        : AppStrings.settingsSinceDate.replaceFirst(
            '{date}',
            _formatLongDate(profile!.createdAt),
          );

    final imageFile = profile?.photoPath == null
        ? null
        : File(profile!.photoPath!);

    return Row(
      children: [
        ClipOval(
          child: SizedBox(
            height: 88,
            width: 88,
            child: imageFile == null
                ? DecoratedBox(
                    decoration: const BoxDecoration(
                      color: AppColors.accentPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        AppIcons.userAdd,
                        colorFilter: const ColorFilter.mode(
                          AppColors.textPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  )
                : Image.file(imageFile, fit: BoxFit.cover),
          ),
        ),
        Gaps.wLg,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              if (sinceText.isNotEmpty) ...[
                Gaps.hXs,
                Text(
                  sinceText,
                  style: AppTextStyles.body3.copyWith(
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ],
          ),
        ),
        IconButton(
          onPressed: onEdit,
          icon: SvgPicture.asset(
            AppIcons.edit,
            colorFilter: const ColorFilter.mode(
              AppColors.textSecondary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.label,
    required this.onTap,
  });

  final String label;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => unawaited(onTap()),
      borderRadius: AppRadius.lg,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.layerPrimary,
          borderRadius: AppRadius.lg,
          border: Border.all(color: AppColors.layerSecondary),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xl,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              SvgPicture.asset(
                AppIcons.chevronRight,
                colorFilter: const ColorFilter.mode(
                  AppColors.textSecondary,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatLongDate(DateTime date) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  final monthName = months[(date.month - 1).clamp(0, 11)];
  return '$monthName ${date.day}, ${date.year}';
}
