import 'package:finance_flow/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:finance_flow/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/transactions/domain/usecases/save_transaction_usecase.dart';
import 'features/transactions/data/repositories/transaction_repository_impl.dart';
import 'features/transactions/data/datasources/transaction_datasource.dart';
import 'features/transactions/data/datasources/local/transaction_local_datasource_impl.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  //! Features - Transactions

  // Bloc
  // Factory = cria um novo sempre que solicitada (necessário para fechar streams)
  sl.registerFactory(
    () => TransactionBloc(
      saveTransactionUseCase: sl(), // O GetIt busca o UseCase registrado abaixo
    ),
  );

  // Use Case
  // LazySingleton = cria uma vez só e mantém na memória
  sl.registerLazySingleton(() => SaveTransactionUseCase(sl()));

  // Repository
  // Registramos a Interface, mas entregamos a Implementação
  sl.registerLazySingleton<ITransactionRepository>(
    () => TransactionRepositoryImpl(dataSource: sl()),
  );

  // Data Source
  // Registramos a Interface, mas entregamos a Implementação Local
  sl.registerLazySingleton<ITransactionDataSource>(
    () => TransactionLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! External
  // Coisas de fora do app (SharedPreferences, Firebase, HTTP Client)
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
