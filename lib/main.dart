import 'package:flutter/material.dart';
import 'features/transactions/presentation/pages/transaction_page.dart'; // Vamos criar essa página já já
import 'injection_container.dart'
    as di; // Importe como 'di' (Dependency Injection)

void main() async {
  // Garante que o motor do Flutter esteja pronto para plugins (como SharedPreferences)
  WidgetsFlutterBinding.ensureInitialized();

  // INICIALIZA TODAS AS DEPENDÊNCIAS
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Flow',
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      // Por enquanto vamos apontar para a TransactionPage que criaremos a seguir
      home: const TransactionPage(),
    );
  }
}
