import 'package:bloc/bloc.dart';

import '../../constants/app_ids.dart';
import '../../data/models/participant.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/participants_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/repositories/settings_repository.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required ProfileRepository profileRepository,
    required ParticipantsRepository participantsRepository,
    required SettingsRepository settingsRepository,
  }) : _profileRepository = profileRepository,
       _participantsRepository = participantsRepository,
       _settingsRepository = settingsRepository,
       super(const SettingsState.initial());

  final ProfileRepository _profileRepository;
  final ParticipantsRepository _participantsRepository;
  final SettingsRepository _settingsRepository;

  Future<void> load() async {
    final profile = await _profileRepository.getProfile();
    emit(state.copyWith(isLoading: false, profile: profile));
  }

  Future<void> upsertProfile({
    required String name,
    String? photoPath,
  }) async {
    final current = state.profile;
    final profile = UserProfile(
      name: name,
      photoPath: photoPath,
      createdAt: current?.createdAt ?? DateTime.now(),
    );

    await _profileRepository.upsertProfile(profile);
    await _participantsRepository.upsert(
      Participant(
        id: AppIds.profileParticipantId,
        name: name,
        photoPath: photoPath,
        createdAt: profile.createdAt,
      ),
    );

    emit(state.copyWith(profile: profile));
  }

  bool getPushPermissionRequested() =>
      _settingsRepository.getPushPermissionRequested();

  Future<void> setPushPermissionRequested(bool value) =>
      _settingsRepository.setPushPermissionRequested(value);

  Future<void> clearAllData() => _settingsRepository.clearAllData();
}
