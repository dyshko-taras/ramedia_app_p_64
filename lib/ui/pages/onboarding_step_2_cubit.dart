import 'package:bloc/bloc.dart';

import '../../constants/app_strings.dart';
import '../../constants/app_routes.dart';
import '../../data/models/currency.dart';
import '../../data/models/participant.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/participants_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/repositories/settings_repository.dart';
import 'onboarding_step_2_state.dart';

class OnboardingStep2Cubit extends Cubit<OnboardingStep2State> {
  OnboardingStep2Cubit({
    required ProfileRepository profileRepository,
    required ParticipantsRepository participantsRepository,
    required SettingsRepository settingsRepository,
  })  : _profileRepository = profileRepository,
        _participantsRepository = participantsRepository,
        _settingsRepository = settingsRepository,
        super(const OnboardingStep2State.initial());

  final ProfileRepository _profileRepository;
  final ParticipantsRepository _participantsRepository;
  final SettingsRepository _settingsRepository;

  Future<void> load() async {
    final profile = await _profileRepository.getProfile();
    final participants = await _participantsRepository.getAll();
    final currencyCode = _settingsRepository.getSelectedCurrencyCode();

    emit(
      state.copyWith(
        profile: profile,
        participants: participants,
        selectedCurrency:
            currencyCode == null ? null : CurrencyX.fromCode(currencyCode),
        isLoading: false,
      ),
    );
  }

  Future<void> saveProfile({
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
    emit(state.copyWith(profile: profile));
  }

  Future<void> addParticipant({
    required String name,
    String? photoPath,
  }) async {
    if (!state.canAddParticipant) {
      emit(
        state.copyWith(
          message: AppStrings.onboardingStep2Hint,
          messageVersion: state.messageVersion + 1,
        ),
      );
      return;
    }

    final participant = Participant(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      photoPath: photoPath,
      createdAt: DateTime.now(),
    );

    await _participantsRepository.upsert(participant);
    final updated = [...state.participants, participant]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    emit(state.copyWith(participants: updated));
  }

  Future<void> deleteParticipant(String id) async {
    await _participantsRepository.deleteById(id);
    emit(
      state.copyWith(
        participants: state.participants.where((p) => p.id != id).toList(),
      ),
    );
  }

  Future<void> selectCurrency(Currency currency) async {
    await _settingsRepository.setSelectedCurrencyCode(currency.code);
    emit(state.copyWith(selectedCurrency: currency));
  }

  Future<void> skip() async {
    await _settingsRepository.setOnboardingCompleted(true);
    if (state.selectedCurrency == null) {
      await selectCurrency(Currency.usd);
    }
    emit(state.copyWith(nextRoute: AppRoutes.home));
  }

  Future<void> continueNext() async {
    if (!state.canContinue) return;
    emit(state.copyWith(isSubmitting: true));
    await _settingsRepository.setOnboardingCompleted(true);
    emit(state.copyWith(isSubmitting: false, nextRoute: AppRoutes.home));
  }

  void acknowledgeMessage() {
    emit(state.copyWith(clearMessage: true));
  }

  void acknowledgeNavigation() {
    emit(state.copyWith(clearNextRoute: true));
  }
}
