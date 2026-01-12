import '../local/hive/hive_store.dart';
import '../local/hive/participants_dao.dart';
import '../models/participant.dart';

class ParticipantsRepository {
  ParticipantsRepository({required HiveStore hive}) : _hive = hive;

  final HiveStore _hive;

  Future<List<Participant>> getAll() async {
    final box = await _hive.openParticipants();
    return ParticipantsDao(box).getAll();
  }

  Future<Participant?> getById(String id) async {
    final box = await _hive.openParticipants();
    return ParticipantsDao(box).getById(id);
  }

  Future<void> upsert(Participant participant) async {
    final box = await _hive.openParticipants();
    await ParticipantsDao(box).upsert(participant);
  }

  Future<void> deleteById(String id) async {
    final box = await _hive.openParticipants();
    await ParticipantsDao(box).deleteById(id);
  }
}

