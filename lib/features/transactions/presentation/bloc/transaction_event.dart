part of 'transaction_bloc.dart';

abstract class TransactionEvent {}

class TransactionStarted extends TransactionEvent {}

class TransactionFilterChanged extends TransactionEvent {
  final TransactionFilter filter;
  TransactionFilterChanged(this.filter);
}

class TransactionDeleted extends TransactionEvent {
  final String transactionId;
  TransactionDeleted(this.transactionId);
}
