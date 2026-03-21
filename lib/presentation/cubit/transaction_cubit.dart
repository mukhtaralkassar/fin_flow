
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/transaction_enums.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import 'transaction_state.dart';

/// Cubit managing the state of transactions and their categorizations.
class TransactionCubit extends Cubit<TransactionState> {
  final TransactionRepository repository;

  TransactionCubit({required this.repository}) : super(TransactionInitial());

  /// Loads all transactions from the repository.
  Future<void> loadTransactions() async {
    emit(TransactionLoading());
    try {
      final transactions = await repository.getTransactions();
      _calculateAndEmitLoadedState(transactions);
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  /// Adds a new transaction to the database and refreshes state
  Future<void> addTransaction(TransactionEntity transaction) async {
    try {
      await repository.addTransaction(transaction);
      // Reload everything to recalculate totals safely
      await loadTransactions();
    } catch (e) {
      emit(const TransactionError("Failed to add transaction"));
    }
  }

  /// Updates the category of a specific expense transaction and recalculates totals.
  Future<void> categorizeExpense(TransactionEntity transaction, ExpenseCategory newCategory) async {
    if (state is TransactionLoaded) {
      final currentState = state as TransactionLoaded;
      
      // Optimistic UI update: Remove the item from uncategorized list immediately
      final updatedList = currentState.transactions.map((t) {
        if (t.id == transaction.id) {
          return TransactionEntity(
            id: t.id,
            title: t.title,
            amount: t.amount,
            date: t.date,
            type: t.type,
            expenseCategory: newCategory, // Update the category
            counterparty: t.counterparty,
            dueDate: t.dueDate,
          );
        }
        return t;
      }).toList();

      _calculateAndEmitLoadedState(updatedList);

      try {
        // Find the specific updated entity to save
        final updatedTransaction = updatedList.firstWhere((t) => t.id == transaction.id);
        await repository.updateTransaction(updatedTransaction);
      } catch (e) {
        // Revert on failure
        emit(const TransactionError("Failed to save categorization"));
        loadTransactions(); 
      }
    }
  }

  /// Helper to calculate all financial totals and emit the loaded state
  void _calculateAndEmitLoadedState(List<TransactionEntity> allTransactions) {
    double totalBalance = 0;
    double totalDebts = 0;
    double totalLent = 0;
    double needs = 0;
    double wants = 0;

    for (var t in allTransactions) {
      switch (t.type) {
        case TransactionType.income:
          totalBalance += t.amount;
          break;
        case TransactionType.expense:
          totalBalance -= t.amount;
          if (t.expenseCategory == ExpenseCategory.need) {
            needs += t.amount;
          } else if (t.expenseCategory == ExpenseCategory.want) {
            wants += t.amount;
          }
          break;
        case TransactionType.debt:
          // Money came in, but it's a liability
          totalBalance += t.amount;
          totalDebts += t.amount;
          break;
        case TransactionType.lent:
          // Money went out, but it's an asset to be returned
          totalBalance -= t.amount;
          totalLent += t.amount;
          break;
      }
    }

    emit(TransactionLoaded(
      transactions: allTransactions,
      totalBalance: totalBalance,
      totalDebts: totalDebts,
      totalLent: totalLent,
      needsTotal: needs,
      wantsTotal: wants,
    ));
  }
}