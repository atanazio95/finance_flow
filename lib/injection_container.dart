import 'package:finance_flow/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:finance_flow/features/transactions/domain/usecases/get_transaction_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Imports da Feature Transaction
import 'features/transactions/presentation/bloc/transaction_bloc.dart';
import 'features/transactions/domain/usecases/save_transaction_usecase.dart';
import 'features/transactions/data/repositories/transaction_repository_impl.dart';
import 'features/transactions/data/datasources/transaction_datasource.dart';
import 'features/transactions/data/datasources/local/transaction_local_datasource_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Transactions

  // Bloc
  // ATENÇÃO: Atualize aqui para passar os DOIS UseCases
  sl.registerFactory(
    () => TransactionBloc(
      saveTransactionUseCase: sl(), // Já existia
      getTransactionsUseCase:
          sl(), // <--- NOVO: O GetIt busca o usecase de baixo
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => SaveTransactionUseCase(sl()));
  sl.registerLazySingleton(
    () => GetTransactionsUseCase(sl()),
  ); // <--- NOVO: Registrando o Get

  // Repository (Não muda nada)
  sl.registerLazySingleton<ITransactionRepository>(
    () => TransactionRepositoryImpl(dataSource: sl()),
  );

  // Data Source (Não muda nada)
  sl.registerLazySingleton<ITransactionDataSource>(
    () => TransactionLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
