
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getTransactions();
  Future<void> saveTransaction(TransactionModel transaction);
  Future<void> updateTransaction(TransactionModel transaction);
}

/// Real implementation using SharedPreferences for offline local storage.
class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  static const String _storageKey = 'finflow_transactions';
  final SharedPreferences sharedPreferences;

  TransactionLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final jsonStringList = sharedPreferences.getStringList(_storageKey);
    if (jsonStringList != null) {
      return jsonStringList
          .map((jsonString) => TransactionModel.fromJson(jsonDecode(jsonString)))
          .toList();
    }
    return [];
  }

  @override
  Future<void> saveTransaction(TransactionModel transaction) async {
    final transactions = await getTransactions();
    transactions.add(transaction);
    await _saveListToPrefs(transactions);
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    final transactions = await getTransactions();
    final index = transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      transactions[index] = transaction;
      await _saveListToPrefs(transactions);
    }
  }

  /// Helper method to save the updated list back to SharedPreferences
  Future<void> _saveListToPrefs(List<TransactionModel> transactions) async {
    final jsonStringList = transactions.map((t) => jsonEncode(t.toJson())).toList();
    await sharedPreferences.setStringList(_storageKey, jsonStringList);
  }
}