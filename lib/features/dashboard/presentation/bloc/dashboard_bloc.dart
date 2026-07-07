import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack/features/dashboard/data/models/monthly_data_model.dart';
import 'package:fintrack/features/dashboard/data/models/transaction_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DashboardBloc() : super(const DashboardState()) {
    on<DashboardStarted>(_onDashboardStarted);
    on<DashboardRefreshed>(_onDashboardStarted);
    on<DashboardBarTapped>(_onBarTapped);
  }
  Future<void> _onDashboardStarted(
    DashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));
    try {
      //Get current logged in user
      final user = _auth.currentUser;
      print("user: $user");
      if (user == null) {
        emit(
          state.copyWith(
            status: DashboardStatus.failure,
            errorMessage: "User not found. Please login again.",
          ),
        );
        return;
      }

      // Get user's first name from display name.
      final fullName = user.displayName ?? 'U ser';
      final firstName = fullName.split(' ').first;

      //fetch all transactions from firestore

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .orderBy('date', descending: true)
          .get();

      //convert firestore docs to transactionmodel list

      final transactions = snapshot.docs
          .map((doc) => TransactionModel.fromMap(doc.data(), doc.id))
          .toList();

      //calculate totals
      double totalIncome = 0;
      double totalExpense = 0;

      for (final txn in transactions) {
        if (txn.isIncome) {
          totalIncome += txn.amount;
        } else {
          totalExpense += txn.amount;
        }
      }

      final totalBalance = totalIncome - totalExpense;

      //only show 5 most recent transactions on dashboard
      final recentTransactions = transactions.take(5).toList();
      final monthlyData = _calculateMonthlyData(transactions);

      emit(
        state.copyWith(
          status: DashboardStatus.success,
          userName: firstName,
          totalBalance: totalBalance,
          totalIncome: totalIncome,
          totalExpense: totalExpense,
          recentTransactions: recentTransactions,
          monthlyData: monthlyData,
        ),
      );
    } catch (e) {
      print('Database Error :$e');
      emit(
        state.copyWith(
          status: DashboardStatus.failure,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  List<MonthlyData> _calculateMonthlyData(List<TransactionModel> transactions) {
    final now = DateTime.now();
    final List<MonthlyData> result = [];
    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthTxns = transactions
          .where(
            (t) => t.date.month == month.month && t.date.year == month.year,
          )
          .toList();

      double income = 0;
      double expense = 0;
      for (final txn in monthTxns) {
        if (txn.isIncome) {
          income += txn.amount;
        } else {
          expense += txn.amount;
        }
      }
      final monthNames = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      print(
        'Month ${monthNames[month.month - 1]}: income=$income , expense =$expense',
      );
      result.add(
        MonthlyData(
          month: monthNames[month.month - 1],
          expense: expense,
          income: income,
        ),
      );
    }
    return result;
  }

  void _onBarTapped(DashboardBarTapped event, Emitter<DashboardState> emit) {
    if (state.selectedMonth == event.month) {
      emit(state.copyWith(clearSelectedMonth: true));
    } else {
      emit(state.copyWith(selectedMonth: event.month));
    }
  }
}
