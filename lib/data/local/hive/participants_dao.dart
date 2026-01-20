import 'package:hive/hive.dart';

import '../../models/participant.dart';

class ParticipantsDao {
  ParticipantsDao(this._box);

  final Box<Map<dynamic, dynamic>> _box;

  List<Participant> getAll() => _box.values
      .map((m) => Participant.fromMap(m.cast<Object?, Object?>()))
      .where((p) => p.id.isNotEmpty)
      .toList()
    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  Participant? getById(String id) {
    final map = _box.get(id);
    if (map == null) return null;
    return Participant.fromMap(map.cast<Object?, Object?>());
  }

  Future<void> upsert(Participant participant) =>
      _box.put(participant.id, participant.toMap());

  Future<void> deleteById(String id) => _box.delete(id);

  Future<void> clear() => _box.clear();
}
