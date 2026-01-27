import 'package:flutter_test/flutter_test.dart';
import 'package:finance_flow/features/transactions/domain/entities/transaction_entity.dart'; // Ajuste o import conforme seu projeto
import 'package:finance_flow/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:finance_flow/features/transactions/domain/usecases/add_transaction_usecase.dart';

// MOCK: Uma classe falsa que finge ser o repositório real.
// Ela implementa a interface, cumprindo o contrato.
class MockTransactionRepository implements ITransactionRepository {
  // Variável para sabermos se o método foi chamado
  bool wasSaveCalled = false;

  @override
  Future<void> saveTransaction(TransactionEntity transaction) async {
    wasSaveCalled = true;
    return; // Simula um sucesso (void)
  }

  @override
  Future<void> deleteTransaction(String id) async {
    // Deixamos vazio ou lançamos erro, pois este teste não usa esse método.
  }

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    // Retornamos uma lista vazia só para cumprir o contrato.
    return [];
  }
}

void main() {
  late AddTransactionUseCase useCase;
  late MockTransactionRepository mockRepository;

  // setUp roda antes de cada teste individual
  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = AddTransactionUseCase(mockRepository);
  });

  group('AddTransactionUseCase |', () {
    test(
      'Deve salvar a transação com sucesso quando o valor for positivo',
      () async {
        // Arrange (Preparação)
        final transaction = TransactionEntity(
          id: '1',
          description: 'Salário',
          value: 5000.0,
          date: DateTime.now(),
          type: TransactionType.outflow,
          category: "Lazer",
        );

        // Act (Ação)
        await useCase(transaction);

        // Assert (Verificação)
        // Verificamos se o "dublê" foi acionado
        expect(mockRepository.wasSaveCalled, true);
      },
    );

    test(
      'Deve lançar uma Exception quando o valor for zero ou negativo',
      () async {
        // Arrange
        final transaction = TransactionEntity(
          id: '2',
          description: 'Erro',
          value: 0.0, // Valor inválido
          date: DateTime.now(),
          type: TransactionType.outflow,
          category: "Alimentação",
        );

        // Act & Assert
        // Esperamos que a chamada lance uma Exception
        expect(() => useCase(transaction), throwsException);

        // Verifica se o repositório NÃO foi chamado (protegemos o banco de dados)
        expect(mockRepository.wasSaveCalled, false);
      },
    );
  });
}
