import '../../model/pass/pass.dart';

class PassDto {
  static const String idKey = 'id';
  static const String userIdKey = 'userId';
  static const String paymentIdKey = 'paymentId';
  static const String typeKey = 'type';
  static const String purchasedAtKey = 'purchasedAt';
  static const String expiresAtKey = 'expiresAt';

  static Pass fromJson(String id, Map<String, dynamic> json) {
    final userId = json[userIdKey] as String?;
    final paymentId = json[paymentIdKey] as String?;
    final typeStr = json[typeKey] as String?;
    final purchasedAtStr = json[purchasedAtKey] as String?;
    final expiresAtStr = json[expiresAtKey] as String?;

    assert(userId != null && userId.isNotEmpty, 'Pass $id: missing userId');
    assert(paymentId != null && paymentId.isNotEmpty, 'Pass $id: missing paymentId');
    assert(typeStr != null && typeStr.isNotEmpty, 'Pass $id: missing type');
    assert(purchasedAtStr != null && purchasedAtStr.isNotEmpty, 'Pass $id: missing purchasedAt');
    assert(expiresAtStr != null && expiresAtStr.isNotEmpty, 'Pass $id: missing expiresAt');

    return Pass(
      id: id,
      userId: userId!,
      paymentId: paymentId!,
      type: PassType.values.byName(typeStr!),
      purchasedAt: DateTime.parse(purchasedAtStr!),
      expiresAt: DateTime.parse(expiresAtStr!),
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
