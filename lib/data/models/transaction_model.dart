
import '../../domain/entities/transaction_enums.dart';
import '../../domain/entities/transaction_entity.dart';

/// Data model representing a transaction, extending the domain entity.
/// Includes JSON serialization for SharedPreferences storage.
class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.date,
    required super.type,
    required super.expenseCategory,
    super.counterparty,
    super.dueDate,
  });

  /// Creates a copy of the model with updated fields.
  TransactionModel copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    TransactionType? type,
    ExpenseCategory? expenseCategory,
    String? counterparty,
    DateTime? dueDate,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
      expenseCategory: expenseCategory ?? this.expenseCategory,
      counterparty: counterparty ?? this.counterparty,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  /// Factory constructor to create a model from JSON map.
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      title: json['title'],
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => TransactionType.expense,
      ),
      expenseCategory: ExpenseCategory.values.firstWhere(
        (e) => e.toString() == json['expenseCategory'],
        orElse: () => ExpenseCategory.uncategorized,
      ),
      counterparty: json['counterparty'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
    );
  }

  /// Converts the model to JSON map for local storage.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type.toString(),
      'expenseCategory': expenseCategory.toString(),
      'counterparty': counterparty,
      'dueDate': dueDate?.toIso8601String(),
    };
  }
}