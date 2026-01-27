import 'package:finance_flow/features/transactions/domain/entities/transaction_entity.dart';
import 'package:finance_flow/features/transactions/domain/repositories/transaction_repository.dart';

class AddTransactionUseCase {
  final ITransactionRepository repository;

  // Inversão de Dependência: Recebemos a interface por injeção
  AddTransactionUseCase(this.repository);

  // O método 'call' permite chamar a classe como se fosse uma função
  Future<void> call(TransactionEntity transaction) async {
    // Aqui poderíamos ter validações de regra de negócio.
    // Ex: "Não permitir transação com valor negativo ou zero"
    if (transaction.value <= 0) {
      throw Exception("O valor da transação deve ser positivo.");
    }

    // Repassa para o repositório (contrato)
    return await repository.saveTransaction(transaction);
  }
}
