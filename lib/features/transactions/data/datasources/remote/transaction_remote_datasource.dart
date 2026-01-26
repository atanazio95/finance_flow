import '../../models/transaction_model.dart';

// Primeiro definimos o contrato do DataSource
abstract class ITransactionRemoteDataSource {
  Future<List<TransactionModel>> getTransactions();
}

// Agora a implementação real
class TransactionRemoteDataSourceImpl implements ITransactionRemoteDataSource {
  // Aqui você injetaria o seu cliente HTTP (ex: Dio ou Http)
  // final HttpClient client;
  // TransactionRemoteDataSourceImpl(this.client);

  @override
  Future<List<TransactionModel>> getTransactions() async {
    // Simulando uma chamada de API para o seu Finance Flow
    await Future.delayed(const Duration(seconds: 1));

    // Imagine que isso veio do corpo da resposta da API (JSON)
    final List<dynamic> response = [
      {
        'id': '1',
        'description': 'Salário Mensal',
        'value': 5000.0,
        'date': '2026-01-20T10:00:00Z',
        'type': 'inflow',
        'category': 'Trabalho',
      },
      {
        'id': '2',
        'description': 'Aluguel',
        'value': 1200.0,
        'date': '2026-01-21T15:30:00Z',
        'type': 'outflow',
        'category': 'Gastos Mensais',
      },
    ];

    // Convertemos a lista de JSONs para uma lista de Models
    return response.map((json) => TransactionModel.fromJson(json)).toList();
  }
}
