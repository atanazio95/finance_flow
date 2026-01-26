import '../models/transaction_model.dart';

// ESSA é a classe que está dando erro de "Undefined".
// Ela é a "Mãe" tanto do Local quanto do Remote.
abstract class ITransactionDataSource {
  Future<void> saveTransaction(TransactionModel transaction);
  Future<List<TransactionModel>> getTransactions();
  Future<void> deleteTransaction(String id);
}
