import '../../model/payment/payment.dart';

class PaymentDto {
  static const String idKey = 'id';
  static const String userIdKey = 'userId';
  static const String amountKey = 'amount';
  static const String methodKey = 'method';
  static const String statusKey = 'status';
  static const String purposeKey = 'purpose';
  static const String createdAtKey = 'createdAt';

  static Payment fromJson(String id, Map<String, dynamic> json) {
    assert(json[idKey] is String);
    assert(json[userIdKey] is String);
    assert(json[amountKey] is num);
    assert(json[methodKey] is String);
    assert(json[statusKey] is String);
    assert(json[purposeKey] is String);
    assert(json[createdAtKey] is String);

    return Payment(
      id: json[idKey],
      userId: json[userIdKey],
      amount: (json[amountKey] as num).toDouble(),
      method: PaymentMethod.values.byName(json[methodKey]),
      status: PaymentStatus.values.byName(json[statusKey]),
      purpose: PaymentPurpose.values.byName(json[purposeKey]),
      createdAt: DateTime.parse(json[createdAtKey]),
    );
  }

  /// Convert Payment to JSON
  static Map<String, dynamic> toJson(Payment payment) {
    return {
      idKey: payment.id,
      userIdKey: payment.userId,
      amountKey: payment.amount,
      methodKey: payment.method.name,
      statusKey: payment.status.name,
      purposeKey: payment.purpose.name,
      createdAtKey: payment.createdAt.toIso8601String(),
    };
  }
}
