import 'package:equatable/equatable.dart';
import 'package:finance_flow/features/transactions/domain/entities/transaction_entity.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class SaveTransactionEvent extends TransactionEvent {
  final TransactionEntity transaction;

  const SaveTransactionEvent({required this.transaction});

  @override
  List<Object> get props => [transaction];
}

class GetTransactionsEvent extends TransactionEvent {}

class DeleteTransactionEvent extends TransactionEvent {
  final TransactionEntity transaction;
  DeleteTransactionEvent({required this.transaction});
}
