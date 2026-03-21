
import 'package:equatable/equatable.dart';
import 'transaction_enums.dart';

/// Core business logic entity for a Transaction.
class TransactionEntity extends Equatable {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final ExpenseCategory expenseCategory;
  final String? counterparty; // Name of the person for debts/lent
  final DateTime? dueDate;    // Expected return date for debts/lent

  const TransactionEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.expenseCategory,
    this.counterparty,
    this.dueDate,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        amount,
        date,
        type,
        expenseCategory,
        counterparty,
        dueDate,
      ];
}