import 'package:equatable/equatable.dart';

class Participant extends Equatable {
  const Participant({
    required this.id,
    required this.name,
    required this.createdAt,
    this.photoPath,
  });

  final String id;
  final String name;
  final String? photoPath;
  final DateTime createdAt;

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'photoPath': photoPath,
        'createdAt': createdAt.toIso8601String(),
      };

  static Participant fromMap(Map<Object?, Object?> map) {
    final createdAtRaw = map['createdAt'] as String?;
    return Participant(
      id: (map['id'] as String?) ?? '',
      name: (map['name'] as String?) ?? '',
      photoPath: map['photoPath'] as String?,
      createdAt: createdAtRaw == null
          ? DateTime.fromMillisecondsSinceEpoch(0)
          : DateTime.parse(createdAtRaw),
    );
  }

  @override
  List<Object?> get props => [id, name, photoPath, createdAt];
}

