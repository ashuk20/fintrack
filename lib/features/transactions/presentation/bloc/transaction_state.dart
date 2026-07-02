part of 'transaction_bloc.dart';

enum TransactionFilter { all, income, expense, thisMonth, lastMonth }

enum TransactionStatus { initial, loading, success, failure }

class TransactionState {
  final TransactionStatus status;
  final List<TransactionModel> allTransactions;
  final List<TransactionModel> filteredTransactions;
  final TransactionFilter activeFilter;
  final String? errorMessage;

  TransactionState({
    this.status = TransactionStatus.initial,
    this.allTransactions = const [],
    this.filteredTransactions = const [],
    this.activeFilter = TransactionFilter.all,
    this.errorMessage,
  });

  double get totalIncome => filteredTransactions
      .where((t) => t.isIncome)
      .fold(0, (sum, t) => sum + t.amount);

  double get totalExpense => filteredTransactions
      .where((t) => !t.isIncome)
      .fold(0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpense;

  Map<String, List<TransactionModel>> get groupedTransactions {
    final Map<String, List<TransactionModel>> grouped = {};
    for (final txn in filteredTransactions) {
      final key =
          '${txn.date.year}-${txn.date.month.toString().padLeft(2, '0')}';

      grouped.putIfAbsent(key, () => []).add(txn);
    }
    return grouped;
  }

  TransactionState copyWith({
    TransactionStatus? status,
    List<TransactionModel>? allTransactions,
    List<TransactionModel>? filteredTransactions,
    TransactionFilter? activeFilter,
    String? errorMessage,
  }) {
    return TransactionState(
      status: status ?? this.status,
      allTransactions: allTransactions ?? this.allTransactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      activeFilter: activeFilter ?? this.activeFilter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
