import 'package:finance_flow/features/transactions/domain/usecases/save_transaction_usecase.dart';
import 'package:finance_flow/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:finance_flow/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  // Dependência do UseCase
  final SaveTransactionUseCase saveTransactionUseCase;

  TransactionBloc({required this.saveTransactionUseCase})
    : super(TransactionInitial()) {
    // Mapeamento: Quando vier o evento Save -> Faça isso
    on<SaveTransactionEvent>(_onSaveTransaction);
  }

  Future<void> _onSaveTransaction(
    SaveTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    // 1. Emite Loading (mostra spinner na tela)
    emit(TransactionLoading());

    try {
      // 2. Chama o UseCase passando a entidade que veio no evento
      await saveTransactionUseCase(event.transaction);

      // 3. Se não deu erro, emite Sucesso
      emit(TransactionSuccess());
    } catch (e) {
      // 4. Se deu erro, emite o estado de Erro com a mensagem
      emit(TransactionError(message: "Erro ao salvar transação: $e"));
    }
  }
}
