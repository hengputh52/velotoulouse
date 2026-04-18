import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velotoulouse/data/dtos/app_user_dto.dart';
import 'package:velotoulouse/data/repositories/user/user_repository.dart';
import 'package:velotoulouse/model/user/user.dart';

class FirebaseAuthRepository implements AuthRepository {
  final Uri usersUri = Uri.https(
    'velotoulouse-42876-default-rtdb.firebaseio.com',
    '/users.json',
  );

  AppUser? _currentUser;

  @override
  AppUser? get currentUser => _currentUser;

  @override
  Future<AppUser?> signInWithEmail(String email, String password) async {
    try {
      // Fetch user by email from Firebase
      final http.Response response = await http.get(usersUri);

      if (response.statusCode == 200) {
        Map<String, dynamic> usersJson = json.decode(response.body);

        for (final entry in usersJson.entries) {
          final userData = entry.value as Map<String, dynamic>;
          if (userData['email'] == email) {
            // In production, verify password (for mock, we just check email)
            _currentUser = AppUserDto.fromJson(entry.key, userData);
            return _currentUser;
          }
        }
        return null;
      } else {
        throw Exception('Failed to sign in');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AppUser> registerWithEmail(String displayName,String email, String password) async {
    try {
      final now = DateTime.now();
      final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      final userData = {
        'id': userId,
        'email': email,
        'displayName': displayName,
        'createdAt': now.toIso8601String(),
      };

      await http.post(
        Uri.https(
          'velotoulouse-42876-default-rtdb.firebaseio.com',
          '/users/$userId.json',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      _currentUser = AppUserDto.fromJson(userId, userData);
      return _currentUser!;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      _currentUser = null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<AppUser?> watchAuthState() async* {
    try {
      if (_currentUser != null) {
        yield _currentUser;
      }
    } catch (e) {
      rethrow;
    }
  }
}
