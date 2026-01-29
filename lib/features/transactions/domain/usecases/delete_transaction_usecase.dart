import 'package:finance_flow/features/transactions/domain/entities/transaction_entity.dart';
import 'package:finance_flow/features/transactions/domain/repositories/transaction_repository.dart';

class DeleteTransactionUsecase {
  final ITransactionRepository repository;

  DeleteTransactionUsecase(this.repository);

  Future<void> delete(TransactionEntity transaction) async {
    if (transaction.id.isEmpty) {
      throw Exception("Transação não encontrada!");
    }
    return await repository.deleteTransaction(transaction.id);
  }
}
