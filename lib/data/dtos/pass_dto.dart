import '../../model/pass/pass.dart';

class PassDto {
  static const String idKey = 'id';
  static const String userIdKey = 'userId';
  static const String paymentIdKey = 'paymentId';
  static const String typeKey = 'type';
  static const String purchasedAtKey = 'purchasedAt';
  static const String expiresAtKey = 'expiresAt';

  static Pass fromJson(String id, Map<String, dynamic> json) {
    assert(json[userIdKey] is String);
    assert(json[paymentIdKey] is String);
    assert(json[typeKey] is String);
    assert(json[purchasedAtKey] is String);
    assert(json[expiresAtKey] is String);

    return Pass(
      id: id,
      userId: json[userIdKey],
      paymentId: json[paymentIdKey],
      type: PassType.values.byName(json[typeKey]),
      purchasedAt: DateTime.parse(json[purchasedAtKey]),
      expiresAt: DateTime.parse(json[expiresAtKey]),
    );
  }

  /// Convert Pass to JSON
  static Map<String, dynamic> toJson(Pass pass) {
    return {
      idKey: pass.id,
      userIdKey: pass.userId,
      paymentIdKey: pass.paymentId,
      typeKey: pass.type.name,
      purchasedAtKey: pass.purchasedAt.toIso8601String(),
      expiresAtKey: pass.expiresAt.toIso8601String(),
    };
  }
}
