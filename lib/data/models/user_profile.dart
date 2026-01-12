import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  const UserProfile({
    required this.name,
    required this.createdAt,
    this.photoPath,
  });

  final String name;
  final String? photoPath;
  final DateTime createdAt;

  Map<String, Object?> toMap() => {
        'name': name,
        'photoPath': photoPath,
        'createdAt': createdAt.toIso8601String(),
      };

  static UserProfile fromMap(Map<Object?, Object?> map) {
    final createdAtRaw = map['createdAt'] as String?;
    return UserProfile(
      name: (map['name'] as String?) ?? '',
      photoPath: map['photoPath'] as String?,
      createdAt: createdAtRaw == null
          ? DateTime.fromMillisecondsSinceEpoch(0)
          : DateTime.parse(createdAtRaw),
    );
  }

  @override
  List<Object?> get props => [name, photoPath, createdAt];
}

