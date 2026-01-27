import 'dart:convert';
import 'package:finance_flow/features/transactions/data/datasources/transaction_datasource.dart';
import 'package:finance_flow/features/transactions/data/models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const CACHED_TRANSACTIONS_KEY = 'CACHED_TRANSACTIONS';

class TransactionLocalDataSourceImpl implements ITransactionDataSource {
  // Vamos injetar o SharedPreferences também, para facilitar testes depois
  final SharedPreferences sharedPreferences;

  TransactionLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveTransaction(TransactionModel transaction) async {
    // 1. Busca a lista atual
    final currentList = await getTransactions();

    // 2. Adiciona o novo item
    currentList.add(transaction);

    // 3. Converte a lista toda para JSON String e salva
    // O map((t) => t.toJson()) transforma cada Model em um Map
    final String jsonString = json.encode(
      currentList.map((t) => t.toJson()).toList(),
    );

    await sharedPreferences.setString(CACHED_TRANSACTIONS_KEY, jsonString);
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    // 1. Pega a String bruta salva no celular
    final jsonString = sharedPreferences.getString(CACHED_TRANSACTIONS_KEY);
    print("DEBUG: Lendo do SharedPreferences: $jsonString");

    if (jsonString != null) {
      // 2. Decodifica a String para uma Lista de Objetos (Dynamic)
      List decodedList = json.decode(jsonString);

      // 3. Transforma cada item da lista em um TransactionModel
      return decodedList
          .map((item) => TransactionModel.fromJson(item))
          .toList();
    } else {
      // Se não tiver nada salvo, retorna lista vazia
      return [];
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    // Busca tudo
    final currentList = await getTransactions();

    // Remove o item com aquele ID
    currentList.removeWhere((item) => item.id == id);

    // Salva a lista atualizada
    final String jsonString = json.encode(
      currentList.map((t) => t.toJson()).toList(),
    );

    await sharedPreferences.setString(CACHED_TRANSACTIONS_KEY, jsonString);
  }
}
