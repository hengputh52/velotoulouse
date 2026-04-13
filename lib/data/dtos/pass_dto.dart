import 'package:velotoulouse/model/pass/pass.dart';

class PassDto {
  final String id;
  final String userId;
  final String paymentId;
  final String type;
  final DateTime purchasedAt;
  final DateTime expiresAt;

  const PassDto({
    required this.id,
    required this.userId,
    required this.paymentId,
    required this.type,
    required this.purchasedAt,
    required this.expiresAt,
  });

  factory PassDto.fromJson(Map<String, dynamic> json) {
    return PassDto(
      id: json['id'] as String,
      userId: json['userId'] as String,
      paymentId: json['paymentId'] as String,
      type: json['type'] as String,
      purchasedAt: _parseDateTime(json['purchasedAt']),
      expiresAt: _parseDateTime(json['expiresAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'paymentId': paymentId,
      'type': type,
      'purchasedAt': purchasedAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  Pass toModel() {
    return Pass(
      id: id,
      userId: userId,
      paymentId: paymentId,
      type: PassType.values.byName(type),
      purchasedAt: purchasedAt,
      expiresAt: expiresAt,
    );
  }

  factory PassDto.fromModel(Pass model) {
    return PassDto(
      id: model.id,
      userId: model.userId,
      paymentId: model.paymentId,
      type: model.type.name,
      purchasedAt: model.purchasedAt,
      expiresAt: model.expiresAt,
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
