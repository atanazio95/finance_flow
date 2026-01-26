import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final String id;
  final String description;
  final double value;
  final DateTime date;
  final TransactionType type; // Entrada ou Saída
  final String category; // Alimentação, Diversão, etc.

  const TransactionEntity({
    required this.id,
    required this.description,
    required this.value,
    required this.date,
    required this.type,
    required this.category,
  });

  @override
  List<Object?> get props => [id, description, value, date, type, category];
}

enum TransactionType { inflow, outflow }
