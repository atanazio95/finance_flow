import 'package:finance_flow/features/transactions/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.description,
    required super.value,
    required super.date,
    required super.type,
    required super.category,
  });

  // 1. A "Conferência de Formato": Transforma JSON em Model
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      // Aqui garantimos que o valor seja double, mesmo que venha int
      value: (json['value'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      type: json['type'] == 'inflow'
          ? TransactionType.inflow
          : TransactionType.outflow,
      category: json['category'] ?? 'Outros',
    );
  }

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      description: entity.description,
      value: entity.value,
      date: entity.date,
      type: entity.type,
      category: entity.category,
    );
  }

  // 2. Transforma o Model em JSON para enviar para a API/Banco
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'value': value,
      'date': date.toIso8601String(),
      'type': type == TransactionType.inflow ? 'inflow' : 'outflow',
      'category': category,
    };
  }
}
