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
  // Controladores para pegar o texto dos campos
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();

  // Valor padrão para o Dropdown (Tipo da transação)
  TransactionType _selectedType = TransactionType.outflow;

  @override
  void dispose() {
    _titleController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _submitTransaction(BuildContext context) {
    final title = _titleController.text;
    final value = double.tryParse(_valueController.text) ?? 0.0;

    if (title.isEmpty || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha os campos corretamente!')),
      );
      return;
    }

    // Cria a entidade
    final transaction = TransactionEntity(
      id: DateTime.now().toString(), // ID temporário
      description: title,
      value: value,
      date: DateTime.now(),
      type: _selectedType,
      category: 'Geral', // Categoria fixa por enquanto
    );

    // Dispara o evento para o BLoC
    context.read<TransactionBloc>().add(
      SaveTransactionEvent(transaction: transaction),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. BlocProvider: Injeta o Bloc na árvore de widgets
    return BlocProvider<TransactionBloc>(
      create: (_) => sl<TransactionBloc>(), // Pega o Bloc pronto do GetIt
      child: Scaffold(
        appBar: AppBar(title: const Text('Nova Transação')),

        // 2. BlocListener: Escuta mudanças de estado para ações únicas (SnackBar, Navegação)
        body: BlocListener<TransactionBloc, TransactionState>(
          listener: (context, state) {
            if (state is TransactionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Transação salva com sucesso! 🚀'),
                ),
              );
              // Limpa os campos
              _titleController.clear();
              _valueController.clear();
            } else if (state is TransactionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },

          // 3. BlocBuilder: Reconstrói a tela baseado no estado (ex: mostrar Loading)
          child: BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              if (state is TransactionLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Título (ex: Almoço)',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _valueController,
                      decoration: const InputDecoration(
                        labelText: 'Valor (ex: 25.00)',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),

                    // Dropdown simples para escolher Entrada ou Saída
                    DropdownButton<TransactionType>(
                      value: _selectedType,
                      items: TransactionType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(
                            type == TransactionType.inflow
                                ? 'Entrada'
                                : 'Saída',
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedType = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _submitTransaction(context),
                      child: const Text('Salvar Transação'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
