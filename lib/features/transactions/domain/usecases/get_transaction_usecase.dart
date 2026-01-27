import 'package:finance_flow/features/transactions/domain/repositories/transaction_repository.dart';

import '../entities/transaction_entity.dart';

class GetTransactionsUseCase {
  final ITransactionRepository repository;

  // Injeção de Dependência via construtor
  GetTransactionsUseCase(this.repository);

  // O método call permite chamar a classe como se fosse uma função
  Future<List<TransactionEntity>> call() async {
    print("DEBUG 3: UseCase - Chamando Repositório...");
    return await repository.getTransactions();

    //   // Ordena: Data mais nova primeiro (descending)
    //   list.sort((a, b) => b.date.compareTo(a.date));

    //   return list;
  }
}
