
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../data_sources/local/transaction_local_data_source.dart';
import '../models/transaction_model.dart';

/// Implementation of the repository that orchestrates data from the local data source.
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl({required this.localDataSource});

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    try {
      return await localDataSource.getTransactions();
    } catch (e) {
      throw Exception('Failed to load transactions');
    }
  }

  @override
  Future<void> addTransaction(TransactionEntity transaction) async {
    try {
      final model = _entityToModel(transaction);
      await localDataSource.saveTransaction(model);
    } catch (e) {
      throw Exception('Failed to save transaction');
    }
  }

  @override
  Future<void> updateTransaction(TransactionEntity transaction) async {
    try {
      final model = _entityToModel(transaction);
      await localDataSource.updateTransaction(model);
    } catch (e) {
      throw Exception('Failed to update transaction');
    }
  }

  /// Helper to convert Entity to Model
  TransactionModel _entityToModel(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      title: entity.title,
      amount: entity.amount,
      date: entity.date,
      type: entity.type,
      expenseCategory: entity.expenseCategory,
      counterparty: entity.counterparty,
      dueDate: entity.dueDate,
    );
  }
}