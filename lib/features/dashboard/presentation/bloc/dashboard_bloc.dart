import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack/features/dashboard/data/models/transaction_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DashboardBloc() : super(const DashboardState()) {
    on<DashboardStarted>(_onDashboardStarted);
    on<DashboardRefreshed>(_onDashboardStarted);
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
      final fullName = user.displayName ?? 'Iser';
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

      emit(
        state.copyWith(
          status: DashboardStatus.success,
          userName: firstName,
          totalBalance: totalBalance,
          totalIncome: totalIncome,
          totalExpense: totalExpense,
          recentTransactions: recentTransactions,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DashboardStatus.failure,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }
}
