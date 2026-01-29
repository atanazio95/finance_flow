import 'package:finance_flow/features/transactions/data/datasources/local/transaction_local_datasource_impl.dart';
import 'package:finance_flow/features/transactions/data/models/transaction_model.dart';
import 'package:finance_flow/features/transactions/domain/entities/transaction_entity.dart';
import 'package:finance_flow/features/transactions/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements ITransactionRepository {
  // AQUI ESTÁ O SEGREDO:
  // Usamos a Interface 'ITransactionDataSource', não o arquivo 'Local' ou 'Remote' direto.
  // Quem decide se vai ser Local ou Remote é a Injeção de Dependência depois.
  final TransactionLocalDataSourceImpl dataSource;

  TransactionRepositoryImpl({required this.dataSource});

  // --- 1. Implementação do SAVE ---
  @override
  Future<void> saveTransaction(TransactionEntity transaction) async {
    final transactionModel = TransactionModel.fromEntity(transaction);
    await dataSource.saveTransaction(transactionModel);
  }

  // --- 2. Implementação do GET (Que estava faltando) ---
  @override
  Future<List<TransactionEntity>> getTransactions() async {
    print("DEBUG: Repository chamado! Chamando DataSource...");
    // Chama o dataSource (seja ele local ou remoto)
    final result = await dataSource.getTransactions();

    // Retorna a lista. Como Model é filho de Entity, isso funciona.
    return result;
  }

  // --- 3. Implementação do DELETE (Que estava faltando) ---
  @override
  Future<void> deleteTransaction(String id) async {
    await dataSource.deleteTransaction(id);
  }
}
