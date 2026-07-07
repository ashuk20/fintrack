part of 'dashboard_bloc.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState {
  final DashboardStatus status;
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;

  final List<TransactionModel> recentTransactions;
  final List<MonthlyData> monthlyData;
  final String userName;
  final String? errorMessage;

  final String? selectedMonth;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.totalBalance = 0.0,
    this.totalIncome = 0.0,
    this.totalExpense = 0.0,
    this.recentTransactions = const [],
    this.monthlyData = const [],
    this.userName = '',
    this.errorMessage,
    this.selectedMonth,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    double? totalBalance,
    double? totalIncome,
    double? totalExpense,
    List<TransactionModel>? recentTransactions,
    List<MonthlyData>? monthlyData,
    String? userName,
    String? errorMessage,
    final String? selectedMonth,
    bool clearSelectedMonth = false,
  }) {
    return DashboardState(
      status: status ?? this.status,
      totalBalance: totalBalance ?? this.totalBalance,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      monthlyData: monthlyData ?? this.monthlyData,
      userName: userName ?? this.userName,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedMonth: clearSelectedMonth
          ? null
          : (selectedMonth ?? this.selectedMonth),
    );
  }
}
