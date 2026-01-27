import 'package:finance_flow/features/transactions/domain/entities/transaction_entity.dart';
import 'package:finance_flow/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:finance_flow/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:finance_flow/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:finance_flow/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  TransactionType _selectedType = TransactionType.outflow;
  int _currentIndex = 1; // Começa na aba do meio (Adicionar)

  @override
  void dispose() {
    _titleController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _submitTransaction(BuildContext context) {
    final title = _titleController.text;
    final value =
        double.tryParse(_valueController.text.replaceAll(',', '.')) ?? 0.0;

    if (title.isEmpty || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Por favor, preencha os dados corretamente.'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final transaction = TransactionEntity(
      id: DateTime.now().toString(),
      description: title,
      value: value,
      date: DateTime.now(),
      type: _selectedType,
      category: 'Geral',
    );

    context.read<TransactionBloc>().add(
      SaveTransactionEvent(transaction: transaction),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Definindo as cores do tema localmente para facilitar
    final primaryColor = Colors.green.shade700;

    return BlocProvider<TransactionBloc>(
      create: (_) => sl<TransactionBloc>()..add(GetTransactionsEvent()),

      child: Scaffold(
        backgroundColor:
            Colors.grey.shade100, // Fundo levemente cinza destaca os cards
        // --- 1. APP BAR MELHORADA ---
        appBar: AppBar(
          title: const Text(
            'Nova Transação',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {}, // Futuramente volta pra Home
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
        ),

        // --- 2. BOTTOM NAVIGATION BAR ---
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() => _currentIndex = index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.add_circle_outline),
              selectedIcon: Icon(Icons.add_circle),
              label: 'Adicionar',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),

        body: BlocConsumer<TransactionBloc, TransactionState>(
          listener: (context, state) {
            if (state is TransactionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Salvo com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
              _titleController.clear();
              _valueController.clear();
              // Força a volta para a aba de lista
              setState(() {
                _currentIndex = 0;
              });
            }
          },
          builder: (context, state) {
            // --- DEBUG VISUAL ---
            // Isso vai imprimir no console qual estado a tela está vendo agora
            print("UI ESTADO ATUAL: $state");

            if (state is TransactionLoading) {
              return Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            }

            // Lógica da Aba 0 (Extrato)
            if (_currentIndex == 0) {
              // AQUI ESTÁ O SEGREDO:
              // Temos que verificar se é Loaded, mas também aceitar Success
              // (pois o success acontece milissegundos antes do reload)
              if (state is TransactionLoaded) {
                print(
                  "UI: Lista recebida com ${state.transactions.length} itens",
                );
                return _buildTransactionList(state.transactions);
              }
              // Se acabou de salvar (Success) ou é o estado inicial,
              // mas ainda não carregou a lista, mostre um loading ou mensagem
              else if (state is TransactionSuccess ||
                  state is TransactionInitial) {
                return const Center(child: Text("Carregando transações..."));
              } else if (state is TransactionError) {
                return Center(child: Text("Erro: ${state.message}"));
              } else {
                return const Center(
                  child: Text("Estado desconhecido na lista."),
                );
              }
            }
            // Lógica da Aba 1 (Formulário)
            else {
              return _buildForm(context, primaryColor);
            }
          },
        ),
      ),
    );
  }

  // Widget auxiliar para os botões de seleção (Entrada/Saída)
  Widget _buildTypeButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // 1. WIDGET DA LISTA (EXTRATO)
  // ---------------------------------------------------------
  Widget _buildTransactionList(List<TransactionEntity> transactions) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.format_list_bulleted,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 10),
            const Text(
              "Nenhuma movimentação ainda.",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Ordena para mostrar o mais recente primeiro
    final sortedList = List.from(transactions.reversed);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedList.length,
      itemBuilder: (context, index) {
        final transaction = sortedList[index];
        final isInflow = transaction.type == TransactionType.inflow;

        // Formata a data simples (Dia/Mês/Ano)
        final dateString =
            "${transaction.date.day.toString().padLeft(2, '0')}/${transaction.date.month.toString().padLeft(2, '0')}/${transaction.date.year}";

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isInflow
                  ? Colors.green.shade100
                  : Colors.red.shade100,
              child: Icon(
                isInflow ? Icons.arrow_upward : Icons.arrow_downward,
                color: isInflow ? Colors.green : Colors.red,
              ),
            ),
            title: Text(
              transaction.description,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              dateString,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            trailing: Text(
              "R\$ ${transaction.value.toStringAsFixed(2)}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isInflow ? Colors.green.shade700 : Colors.red.shade700,
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------
  // 2. WIDGET DO FORMULÁRIO (ADICIONAR)
  // ---------------------------------------------------------
  Widget _buildForm(BuildContext context, Color primaryColor) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      prefixIcon: Icon(Icons.description_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _valueController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Valor',
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Botões de Seleção (Entrada/Saída)
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => _selectedType = TransactionType.inflow),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: _selectedType == TransactionType.inflow
                            ? Colors.green.withOpacity(0.1)
                            : Colors.white,
                        border: Border.all(
                          color: _selectedType == TransactionType.inflow
                              ? Colors.green
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.arrow_upward, color: Colors.green),
                          Text(
                            "Entrada",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => _selectedType = TransactionType.outflow),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: _selectedType == TransactionType.outflow
                            ? Colors.red.withOpacity(0.1)
                            : Colors.white,
                        border: Border.all(
                          color: _selectedType == TransactionType.outflow
                              ? Colors.red
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.arrow_downward, color: Colors.red),
                          Text(
                            "Saída",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () => _submitTransaction(context),
                child: const Text(
                  "SALVAR TRANSAÇÃO",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
