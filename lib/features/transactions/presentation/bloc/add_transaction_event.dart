part of 'add_transaction_bloc.dart';

abstract class AddTransactionEvent {}

class AddTransactionTypeChanged extends AddTransactionEvent {
  final bool isIncome;
  AddTransactionTypeChanged(this.isIncome);
}

class AddTransactionAmountChanged extends AddTransactionEvent {
  final String amount;
  AddTransactionAmountChanged(this.amount);
}

class AddTransactionTitleChanged extends AddTransactionEvent {
  final String title;
  AddTransactionTitleChanged(this.title);
}

class AddTransactionCategoryChanged extends AddTransactionEvent {
  final String category;
  AddTransactionCategoryChanged(this.category);
}

class AddTransactionDateChanged extends AddTransactionEvent {
  final DateTime date;
  AddTransactionDateChanged(this.date);
}

class AddTransactionSubmitted extends AddTransactionEvent {}
