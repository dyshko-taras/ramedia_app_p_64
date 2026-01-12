import 'package:hive/hive.dart';

import '../../models/budget_transaction.dart';

class TransactionsDao {
  TransactionsDao(this._box);

  final Box<Map<String, Object?>> _box;

  List<BudgetTransaction> getAll() => _box.values
      .map(BudgetTransaction.fromMap)
      .where((t) => t.id.isNotEmpty)
      .toList()
    ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

  BudgetTransaction? getById(String id) {
    final map = _box.get(id);
    if (map == null) return null;
    return BudgetTransaction.fromMap(map);
  }

  Future<void> upsert(BudgetTransaction tx) => _box.put(tx.id, tx.toMap());

  Future<void> deleteById(String id) => _box.delete(id);

  Future<void> clear() => _box.clear();
}

