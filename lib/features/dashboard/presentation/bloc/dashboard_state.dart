part of 'dashboard_bloc.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState {
  final DashboardStatus status;
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;

  final List<TransactionModel> recentTransactions;
  final String userName;
  final String? errorMessage;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.totalBalance = 0.0,
    this.totalIncome = 0.0,
    this.totalExpense = 0.0,
    this.recentTransactions = const [],
    this.userName = '',
    this.errorMessage,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    double? totalBalance,
    double? totalIncome,
    double? totalExpense,
    List<TransactionModel>? recentTransactions,
    String? userName,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      totalBalance: totalBalance ?? this.totalBalance,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      userName: userName ?? this.userName,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
