import '../../model/user/user.dart';

class AppUserDto {
  static const String idKey = 'id';
  static const String emailKey = 'email';
  static const String displayNameKey = 'displayName';
  static const String createdAtKey = 'createdAt';

  static AppUser fromJson(String id, Map<String, dynamic> json) {
    assert(json[idKey] is String);
    assert(json[emailKey] is String);
    assert(json[createdAtKey] is String);

    return AppUser(
      id: json[idKey],
      email: json[emailKey],
      displayName: json[displayNameKey],
      createdAt: DateTime.parse(json[createdAtKey]),
    );
  }

  /// Convert AppUser to JSON
  static Map<String, dynamic> toJson(AppUser user) {
    return {
      idKey: user.id,
      emailKey: user.email,
      displayNameKey: user.displayName,
      createdAtKey: user.createdAt.toIso8601String(),
    };
  }
}
