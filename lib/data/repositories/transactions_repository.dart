import '../local/hive/hive_store.dart';
import '../local/hive/transactions_dao.dart';
import '../models/budget_transaction.dart';

class TransactionsRepository {
  TransactionsRepository({required HiveStore hive}) : _hive = hive;

  final HiveStore _hive;

  Future<List<BudgetTransaction>> getAll() async {
    final box = await _hive.openTransactions();
    return TransactionsDao(box).getAll();
  }

  Future<BudgetTransaction?> getById(String id) async {
    final box = await _hive.openTransactions();
    return TransactionsDao(box).getById(id);
  }

  Future<void> upsert(BudgetTransaction tx) async {
    final box = await _hive.openTransactions();
    await TransactionsDao(box).upsert(tx);
  }

  Future<void> deleteById(String id) async {
    final box = await _hive.openTransactions();
    await TransactionsDao(box).deleteById(id);
  }
}

