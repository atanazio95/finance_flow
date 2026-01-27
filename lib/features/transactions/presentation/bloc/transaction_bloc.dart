import 'package:finance_flow/features/transactions/domain/usecases/get_transaction_usecase.dart';
import 'package:finance_flow/features/transactions/domain/usecases/save_transaction_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Imports dos UseCases

import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  // As duas ferramentas que o Bloc precisa
  final SaveTransactionUseCase saveTransactionUseCase;
  final GetTransactionsUseCase getTransactionsUseCase;

  TransactionBloc({
    required this.saveTransactionUseCase,
    required this.getTransactionsUseCase,
  }) : super(TransactionInitial()) {
    print("DEBUG VIDA: O Construtor do TransactionBloc foi iniciado!");
    // Registra os handlers
    on<SaveTransactionEvent>(_onSaveTransaction);
    on<GetTransactionsEvent>(_onGetTransactions);
  }

  @override
  void onEvent(TransactionEvent event) {
    super.onEvent(event);
    print("DEBUG GLOBAL: O BLoC ouviu um evento chegando: $event");
  }

  // Lógica de Salvar
  Future<void> _onSaveTransaction(
    SaveTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());

    try {
      // 1. Tenta salvar
      await saveTransactionUseCase(event.transaction);

      // 2. Se deu certo, avisa a UI (Sucesso)
      emit(TransactionSuccess());

      // 3. AUTOMATICAMENTE pede para recarregar a lista atualizada
      add(GetTransactionsEvent());
    } catch (e) {
      emit(TransactionError(message: "Erro ao salvar: $e"));
    }
  }

  // Lógica de Buscar
  Future<void> _onGetTransactions(
    GetTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {
    print("DEBUG 2: BLoC - Recebi o evento! Chamando UseCase...");
    // Só mostre loading se a lista estiver vazia ou se quiser bloquear a tela
    emit(TransactionLoading());

    try {
      // 1. Busca a lista no UseCase
      final list = await getTransactionsUseCase();

      // 2. Entrega a lista para a UI desenhar
      emit(TransactionLoaded(transactions: list));
    } catch (e) {
      emit(TransactionError(message: "Erro ao buscar extrato: $e"));
    }
  }
}
