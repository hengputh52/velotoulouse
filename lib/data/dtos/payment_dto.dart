import 'package:velotoulouse/model/payment/payment.dart';

class PaymentDto {
  final String id;
  final String userId;
  final double amount;
  final String method;
  final String status;
  final String purpose;
  final DateTime createdAt;

  const PaymentDto({
    required this.id,
    required this.userId,
    required this.amount,
    required this.method,
    required this.status,
    required this.purpose,
    required this.createdAt,
  });

  factory PaymentDto.fromJson(Map<String, dynamic> json) {
    return PaymentDto(
      id: json['id'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      method: json['method'] as String,
      status: json['status'] as String,
      purpose: json['purpose'] as String,
      createdAt: _parseDateTime(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'method': method,
      'status': status,
      'purpose': purpose,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Payment toModel() {
    return Payment(
      id: id,
      userId: userId,
      amount: amount,
      method: PaymentMethod.values.byName(method),
      status: PaymentStatus.values.byName(status),
      purpose: PaymentPurpose.values.byName(purpose),
      createdAt: createdAt,
    );
  }

  factory PaymentDto.fromModel(Payment model) {
    return PaymentDto(
      id: model.id,
      userId: model.userId,
      amount: model.amount,
      method: model.method.name,
      status: model.status.name,
      purpose: model.purpose.name,
      createdAt: model.createdAt,
    );
  }

  static DateTime _parseDateTime(dynamic data) {
    if (data == null) return DateTime.now();
    if (data is DateTime) return data;
    if (data is String) return DateTime.parse(data);
    if (data is Map && data['_seconds'] != null) {
      return DateTime.fromMillisecondsSinceEpoch(
        (data['_seconds'] as int) * 1000,
      );
    }
    return DateTime.now();
  }
}
