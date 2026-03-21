
import 'package:equatable/equatable.dart';
import '../../domain/entities/transaction_entity.dart';

/// Represents the various states of the transaction screen.
abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<TransactionEntity> transactions;
  final double totalBalance;
  final double totalDebts;
  final double totalLent;
  final double needsTotal;
  final double wantsTotal;

  const TransactionLoaded({
    required this.transactions,
    required this.totalBalance,
    required this.totalDebts,
    required this.totalLent,
    required this.needsTotal,
    required this.wantsTotal,
  });

  @override
  List<Object?> get props => [
        transactions,
        totalBalance,
        totalDebts,
        totalLent,
        needsTotal,
        wantsTotal,
      ];
}

class TransactionError extends TransactionState {
  final String message;

  const TransactionError(this.message);

  @override
  List<Object?> get props => [message];
}