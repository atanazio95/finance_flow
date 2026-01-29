import 'package:finance_flow/features/transactions/domain/usecases/get_transaction_usecase.dart';
import 'package:finance_flow/features/transactions/domain/usecases/save_transaction_usecase.dart';
import 'package:finance_flow/features/transactions/domain/usecases/delete_transaction_usecase.dart'; // <--- IMPORT NOVO
import 'package:flutter_bloc/flutter_bloc.dart';

import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  // Agora são TRÊS ferramentas
  final SaveTransactionUseCase saveTransactionUseCase;
  final GetTransactionsUseCase getTransactionsUseCase;
  final DeleteTransactionUsecase
  deleteTransactionUseCase; // <--- NOVA DEPENDÊNCIA

  TransactionBloc({
    required this.saveTransactionUseCase,
    required this.getTransactionsUseCase,
    required this.deleteTransactionUseCase, // <--- Recebe no construtor
  }) : super(TransactionInitial()) {
    // Registra os handlers
    on<SaveTransactionEvent>(_onSaveTransaction);
    on<GetTransactionsEvent>(_onGetTransactions);
    on<DeleteTransactionEvent>(_onDeleteTransaction); // <--- REGISTRA O DELETE
  }

  // ... (onSaveTransaction e onGetTransactions continuam IGUAIS) ...
  // Vou omitir aqui para economizar espaço, mas mantenha os códigos que você já tem.
  // ...

  // --- Lógica de Salvar (Mantive aqui para referência) ---
  Future<void> _onSaveTransaction(
    SaveTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    try {
      await saveTransactionUseCase(event.transaction);
      emit(TransactionSuccess());
      add(GetTransactionsEvent());
    } catch (e) {
      emit(TransactionError(message: "Erro ao salvar: $e"));
    }
  }

  // --- Lógica de Buscar (Mantive aqui para referência) ---
  Future<void> _onGetTransactions(
    GetTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    try {
      final list = await getTransactionsUseCase();
      emit(TransactionLoaded(transactions: list));
    } catch (e) {
      emit(TransactionError(message: "Erro ao buscar: $e"));
    }
  }

  // --- NOVA LÓGICA: DELETAR ---
  Future<void> _onDeleteTransaction(
    DeleteTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    // 1. Loading (opcional, mas bom para evitar cliques duplos)
    emit(TransactionLoading());

    try {
      // 2. Chama o UseCase
      await deleteTransactionUseCase.delete(event.transaction);

      // 3. Sucesso (Para mostrar SnackBar se precisar)
      // Nota: Algumas pessoas preferem não emitir Success no delete,
      // apenas recarregar direto. Mas emitir Success ajuda no feedback visual.
      emit(TransactionSuccess());

      // 4. Recarrega a lista atualizada
      add(GetTransactionsEvent());
    } catch (e) {
      emit(TransactionError(message: "Erro ao deletar: $e"));
    }
  }
}
