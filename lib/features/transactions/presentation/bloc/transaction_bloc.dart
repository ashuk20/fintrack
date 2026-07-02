import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack/features/dashboard/data/models/transaction_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TransactionBloc() : super(TransactionState()) {
    on<TransactionStarted>(_onTransactionStarted);
    on<TransactionFilterChanged>(_onFilterChanged);
    on<TransactionDeleted>(_onTransactionDeleted);
  }
  Future<void> _onTransactionStarted(
    TransactionStarted event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.loading));
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(
          state.copyWith(
            status: TransactionStatus.failure,
            errorMessage: 'User not found.Please login again.',
          ),
        );
        return;
      }
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .orderBy('date', descending: true)
          .get();

      final transactions = snapshot.docs
          .map((doc) => TransactionModel.fromMap(doc.data(), doc.id))
          .toList();

      emit(
        state.copyWith(
          status: TransactionStatus.success,
          allTransactions: transactions,
          filteredTransactions: transactions,
          activeFilter: TransactionFilter.all,
        ),
      );
    } catch (e) {
      print('Transaction error: $e');
      emit(
        state.copyWith(
          status: TransactionStatus.failure,
          errorMessage: 'Failed to load transactions.',
        ),
      );
    }
  }

  void _onFilterChanged(
    TransactionFilterChanged event,
    Emitter<TransactionState> emit,
  ) {
    final all = state.allTransactions;
    final now = DateTime.now();

    List<TransactionModel> filtered;

    switch (event.filter) {
      case TransactionFilter.all:
        filtered = all;
        break;

      case TransactionFilter.income:
        filtered = all.where((t) => t.isIncome).toList();
        break;

      case TransactionFilter.expense:
        filtered = all.where((t) => !t.isIncome).toList();
        break;

      case TransactionFilter.thisMonth:
        filtered = all
            .where((t) => t.date.month == now.month && t.date.year == now.year)
            .toList();
        break;

      case TransactionFilter.lastMonth:
        final lastMonth = DateTime(now.year, now.month - 1);
        filtered = all
            .where(
              (t) =>
                  t.date.month == lastMonth.month &&
                  t.date.year == lastMonth.year,
            )
            .toList();
        break;
    }

    emit(
      state.copyWith(
        filteredTransactions: filtered,
        activeFilter: event.filter,
      ),
    );
  }

  Future<void> _onTransactionDeleted(
    TransactionDeleted event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .doc(event.transactionId)
          .delete();

      final updatedAll = state.allTransactions
          .where((t) => t.id != event.transactionId)
          .toList();

      final updateFiltered = state.filteredTransactions
          .where((t) => t.id != event.transactionId)
          .toList();

      emit(
        state.copyWith(
          allTransactions: updatedAll,
          filteredTransactions: updateFiltered,
        ),
      );
    } catch (e) {
      print("deleted error : $e");
    }
  }
}
