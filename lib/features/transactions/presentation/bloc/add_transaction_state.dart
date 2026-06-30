part of 'add_transaction_bloc.dart';

enum AddTransactionStatus { initial, loading, success, failure }

class AddTransactionState {
  final AddTransactionStatus status;
  final bool isIncome;
  final String amount;
  final String title;
  final String category;
  final DateTime date;
  final String? errorMessage;

  AddTransactionState({
    this.status = AddTransactionStatus.initial,
    this.isIncome = false,
    this.amount = '',
    this.title = '',
    this.category = 'Other',
    DateTime? date,
    this.errorMessage,
  }) : date = date ?? DateTime.now();

  bool get isFormValid =>
      amount.isNotEmpty &&
      double.tryParse(amount) != null &&
      double.parse(amount) > 0 &&
      title.isNotEmpty;

  Color get activeColor =>
      isIncome ? const Color(0xFF4CAF50) : const Color(0xFFef5350);

  AddTransactionState copyWith({
    AddTransactionStatus? status,
    bool? isIncome,
    String? amount,
    String? title,
    String? category,
    DateTime? date,
    String? errorMessage,
  }) {
    return AddTransactionState(
      status: status ?? this.status,
      isIncome: isIncome ?? this.isIncome,
      amount: amount ?? this.amount,
      title: title ?? this.title,
      category: category ?? this.category,
      date: date ?? this.date,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
