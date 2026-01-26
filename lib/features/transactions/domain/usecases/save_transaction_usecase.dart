import 'package:finance_flow/features/transactions/domain/entities/transaction_entity.dart';
import 'package:finance_flow/features/transactions/domain/repositories/transaction_repository.dart';

class SaveTransactionUseCase {
  final ITransactionRepository repository;

  // Recebemos a interface pelo construtor (Injeção de Dependência)
  SaveTransactionUseCase(this.repository);

  Future<void> call(TransactionEntity transaction) async {
    // Aqui você poderia colocar regras de negócio, por exemplo:
    // Não permitir salvar se o valor for zero.
    if (transaction.value <= 0) {
      throw Exception("O valor da transação deve ser maior que zero");
    }

    return await repository.saveTransaction(transaction);
  }
}
