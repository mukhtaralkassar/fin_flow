
import '../entities/transaction_entity.dart';

/// Abstract repository defining the contract for transaction data operations.
abstract class TransactionRepository {
  Future<List<TransactionEntity>> getTransactions();
  Future<void> addTransaction(TransactionEntity transaction);
  Future<void> updateTransaction(TransactionEntity transaction);
}