import 'package:equatable/equatable.dart';
// Não esqueça de importar a sua Entidade aqui!
import '../../domain/entities/transaction_entity.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionSuccess extends TransactionState {}

// --- NOVO ESTADO ADICIONADO ---
class TransactionLoaded extends TransactionState {
  final List<TransactionEntity> transactions;

  const TransactionLoaded({required this.transactions});

  @override
  List<Object> get props => [transactions];
}
// ------------------------------

class TransactionError extends TransactionState {
  final String message;

  const TransactionError({required this.message});

  @override
  List<Object> get props => [message];
}
