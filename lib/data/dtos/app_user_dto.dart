import 'package:velotoulouse/model/user/user.dart';

class AppUserDto {
  final String id;
  final String email;
  final String? displayName;
  final DateTime createdAt;

  const AppUserDto({
    required this.id,
    required this.email,
    this.displayName,
    required this.createdAt,
  });

  factory AppUserDto.fromJson(Map<String, dynamic> json) {
    return AppUserDto(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      createdAt: _parseDateTime(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  AppUser toModel() {
    return AppUser(
      id: id,
      email: email,
      displayName: displayName,
      createdAt: createdAt,
    );
  }

  factory AppUserDto.fromModel(AppUser model) {
    return AppUserDto(
      id: model.id,
      email: model.email,
      displayName: model.displayName,
      createdAt: model.createdAt,
    );
  }

  static DateTime _parseDateTime(dynamic data) {
    if (data == null) return DateTime.now();
    if (data is DateTime) return data;
    if (data is String) return DateTime.parse(data);
    // Handle Firestore Timestamp
    if (data is Map && data['_seconds'] != null) {
      return DateTime.fromMillisecondsSinceEpoch(
        (data['_seconds'] as int) * 1000,
      );
    }
    return DateTime.now();
  }
}
