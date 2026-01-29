import 'dart:convert';
import 'package:finance_flow/features/transactions/data/datasources/transaction_datasource.dart';
import 'package:finance_flow/features/transactions/data/models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const CACHED_TRANSACTIONS_KEY = 'CACHED_TRANSACTIONS';

class TransactionLocalDataSourceImpl implements ITransactionDataSource {
  final SharedPreferences sharedPreferences;

  TransactionLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveTransaction(TransactionModel transaction) async {
    final currentList = await getTransactions();

    currentList.add(transaction);

    final String jsonString = json.encode(
      currentList.map((t) => t.toJson()).toList(),
    );

    await sharedPreferences.setString(CACHED_TRANSACTIONS_KEY, jsonString);
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final jsonString = sharedPreferences.getString(CACHED_TRANSACTIONS_KEY);
    print("DEBUG: Lendo do SharedPreferences: $jsonString");

    if (jsonString != null) {
      List decodedList = json.decode(jsonString);
      return decodedList
          .map((item) => TransactionModel.fromJson(item))
          .toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final currentList = await getTransactions();

    currentList.removeWhere((item) => item.id == id);

    final String jsonString = json.encode(
      currentList.map((t) => t.toJson()).toList(),
    );

    await sharedPreferences.setString(CACHED_TRANSACTIONS_KEY, jsonString);
  }
}
