
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/transaction_enums.dart';
import '../cubit/transaction_cubit.dart';
import '../cubit/transaction_state.dart';
import '../widgets/interactive/swipeable_transaction.dart';
import '../widgets/forms/add_transaction_bottom_sheet.dart';

/// Main screen displaying summaries, debts, and uncategorized expenses.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E272C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return const AddTransactionBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E272C), // Darker Charcoal background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'FinFlow',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF10B981),
        onPressed: () => _startAddNewTransaction(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading || state is TransactionInitial) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF10B981)));
          } else if (state is TransactionError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          } else if (state is TransactionLoaded) {
            // Filter only uncategorized expenses to show in the swipe list
            final pendingExpenses = state.transactions
                .where((t) => 
                  t.type == TransactionType.expense && 
                  t.expenseCategory == ExpenseCategory.uncategorized)
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMainBalance(state.totalBalance),
                const SizedBox(height: 16),
                _buildSecondarySummaries(state.totalDebts, state.totalLent),
                const SizedBox(height: 16),
                _buildNeedsWantsSummaries(state.needsTotal, state.wantsTotal),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Uncategorized Expenses",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: pendingExpenses.isEmpty
                      ? const Center(
                          child: Text(
                            "All expenses sorted! 🎉",
                            style: TextStyle(color: Colors.white54, fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: pendingExpenses.length,
                          itemBuilder: (context, index) {
                            final transaction = pendingExpenses[index];
                            return SwipeableTransaction(
                              transaction: transaction,
                              onSwipeRight: () {
                                context.read<TransactionCubit>().categorizeExpense(
                                      transaction,
                                      ExpenseCategory.need,
                                    );
                              },
                              onSwipeLeft: () {
                                context.read<TransactionCubit>().categorizeExpense(
                                      transaction,
                                      ExpenseCategory.want,
                                    );
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildMainBalance(double balance) {
    return Center(
      child: Column(
        children: [
          const Text('Total Balance', style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            '\$${balance.toStringAsFixed(2)}',
            style: TextStyle(
              color: balance >= 0 ? Colors.white : const Color(0xFFFF6B6B),
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondarySummaries(double debts, double lent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: _MiniSummaryCard(
              title: 'I Owe (Debt)',
              amount: debts,
              color: const Color(0xFFFFB74D), // Orange
              icon: Icons.money_off,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _MiniSummaryCard(
              title: 'Owed To Me',
              amount: lent,
              color: const Color(0xFF64B5F6), // Blue
              icon: Icons.attach_money,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeedsWantsSummaries(double needs, double wants) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: _MiniSummaryCard(
              title: 'Needs Spent',
              amount: needs,
              color: const Color(0xFF10B981), // Emerald
              icon: Icons.check_circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _MiniSummaryCard(
              title: 'Wants Spent',
              amount: wants,
              color: const Color(0xFFFF6B6B), // Coral
              icon: Icons.favorite,
            ),
          ),
        ],
      ),
    );
  }
}

/// A smaller card for displaying various summaries
class _MiniSummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final IconData icon;

  const _MiniSummaryCard({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF263238), // Charcoal Surface
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: amount),
            duration: const Duration(milliseconds: 500),
            builder: (context, value, child) {
              return Text(
                '\$${value.toStringAsFixed(2)}',
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}