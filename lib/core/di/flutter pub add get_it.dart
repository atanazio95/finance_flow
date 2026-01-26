// import 'package:get_it/get_it.dart';

// // Importe seus arquivos aqui (ajuste os caminhos conforme suas pastas)
// // Feature: Transactions
// import 'features/transactions/presentation/bloc/transaction_bloc.dart';
// import 'features/transactions/domain/usecases/add_transaction_usecase.dart';
// import 'features/transactions/domain/repositories/transaction_repository_interface.dart';
// import 'features/transactions/data/repositories/transaction_repository_impl.dart';
// import 'features/transactions/data/datasources/transaction_datasource.dart';


// final sl = GetIt.instance;

// Future<void> init() async {

  

//   sl.registerFactory(
//     () => TransactionBloc(
//       addTransactionUseCase: sl(), 
//     ),
//   );


//   sl.registerLazySingleton(
//     () => AddTransactionUseCase(sl()), // O 'sl()' busca o Repositório
//   );

//   // 3. Data (Repositories)
//   // Registramos a INTERFACE (<ITransactionRepository>), mas entregamos a IMPLEMENTAÇÃO.
//   sl.registerLazySingleton<ITransactionRepository>(
//     () => TransactionRepositoryImpl(
//       dataSource: sl(), // O 'sl()' busca o DataSource
//     ),
//   );

//   // 4. Data (Data Sources)
//   // A classe que toca no banco de dados ou API.
//   sl.registerLazySingleton<ITransactionDataSource>(
//     () => TransactionDataSourceImpl(),
//   );

//   //! Core & External (Coisas globais)
//   // Se você usar HTTP, SharedPrefs, Firebase, registra aqui também.
//   // Exemplo:
//   // sl.registerLazySingleton(() => http.Client());
// }