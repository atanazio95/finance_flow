import 'package:finance_flow/features/transactions/domain/entities/transaction_entity.dart';

abstract class ITransactionRepository {
  Future<List<TransactionEntity>> getTransactions();

  Future<void> saveTransaction(TransactionEntity transaction);

  Future<void> deleteTransaction(String id);
}
