import 'package:equatable/equatable.dart';

import '../../data/models/user_profile.dart';

class SettingsState extends Equatable {
  const SettingsState({
    required this.isLoading,
    required this.profile,
  });

  const SettingsState.initial() : isLoading = true, profile = null;

  final bool isLoading;
  final UserProfile? profile;

  SettingsState copyWith({
    bool? isLoading,
    UserProfile? profile,
    bool clearProfile = false,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      profile: clearProfile ? null : (profile ?? this.profile),
    );
  }

  @override
  List<Object?> get props => [isLoading, profile];
}
