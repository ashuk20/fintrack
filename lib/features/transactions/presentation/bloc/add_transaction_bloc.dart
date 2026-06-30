import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack/features/dashboard/data/models/transaction_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'add_transaction_event.dart';
part 'add_transaction_state.dart';

class AddTransactionBloc
    extends Bloc<AddTransactionEvent, AddTransactionState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AddTransactionBloc() : super(AddTransactionState()) {
    on<AddTransactionTypeChanged>((event, emit) {
      emit(state.copyWith(isIncome: event.isIncome));
    });

    on<AddTransactionAmountChanged>((event, emit) {
      emit(state.copyWith(amount: event.amount));
    });

    on<AddTransactionCategoryChanged>((event, emit) {
      emit(state.copyWith(category: event.category));
    });

    on<AddTransactionTitleChanged>((event, emit) {
      emit(state.copyWith(title: event.title));
    });

    on<AddTransactionDateChanged>((event, emit) {
      emit(state.copyWith(date: event.date));
    });
    on<AddTransactionSubmitted>((event, emit) async {
      if (!state.isFormValid) {
        emit(
          state.copyWith(
            status: AddTransactionStatus.failure,
            errorMessage: 'Please fill amount and title correctly.',
          ),
        );
        return;
      }
      emit(state.copyWith(status: AddTransactionStatus.loading));

      try {
        final user = _auth.currentUser;
        if (user == null) {
          emit(
            state.copyWith(
              status: AddTransactionStatus.failure,
              errorMessage: 'User not found. Please login again.',
            ),
          );
          return;
        }

        final transaction = TransactionModel(
          id: '',
          title: state.title.trim(),
          amount: double.parse(state.amount),
          isIncome: state.isIncome,
          date: state.date,
          category: state.category,
        );

        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('transactions')
            .add(transaction.toMap());

        emit(state.copyWith(status: AddTransactionStatus.success));
      } catch (e) {
        print("Add transaction error: $e");
        emit(
          state.copyWith(
            status: AddTransactionStatus.failure,
            errorMessage: 'Faield to save.Please try again,',
          ),
        );
      }
    });
  }
}
