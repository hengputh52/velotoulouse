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
      print('🔐 Attempting login with email: $email');
      // Fetch all users from Firebase
      final http.Response response = await http.get(usersUri);

      if (response.statusCode == 200) {
        if (response.body == 'null' || response.body.isEmpty) {
          print('❌ No users in database');
          return null;
        }

        Map<String, dynamic> usersJson = json.decode(response.body);
        print('📍 Searching through users...');

        // Iterate through each user document (user_1776499923728, etc)
        for (final userEntry in usersJson.entries) {
          final userValue = userEntry.value;
          print('🔍 Checking user group: ${userEntry.key}');

          // Handle nested structure: user_XXX -> { -OqUd...: { email, displayName, password, ... } }
          if (userValue is Map<String, dynamic>) {
            // Get the first (and usually only) nested document
            if (userValue.isNotEmpty) {
              final nestedData = userValue.values.first as Map<String, dynamic>;
              final userEmail = nestedData['email'];
              print('👤 Found user with email: $userEmail');
              
              if (userEmail == email) {
                print('✅ Email matched!');
                
                // Verify password
                final storedPassword = nestedData['password'] as String?;
                
                if (storedPassword == null || storedPassword.isEmpty) {
                  print('⚠️ No password set - allowing login (legacy account)');
                  _currentUser = AppUserDto.fromJson(userEntry.key, nestedData);
                  return _currentUser;
                }
                
                if (storedPassword != password) {
                  print('❌ Password mismatch!');
                  return null;
                }
                
                print('✅ Login successful!');
                _currentUser = AppUserDto.fromJson(userEntry.key, nestedData);
                return _currentUser;
              }
            }
          }
        }
        print('❌ User not found with email: $email');
        return null;
      } else {
        print('❌ Server error: ${response.statusCode}');
        throw Exception('Failed to sign in: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Login exception: $e');
      rethrow;
    }
  }

  @override
  Future<AppUser> registerWithEmail(
    String displayName,
    String email,
    String password,
  ) async {
    try {
      print('👥 Registering new user: $email');
      final now = DateTime.now();
      final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      final userData = {
        'id': userId,
        'email': email,
        'displayName': displayName,
        'password': password,  // ← Store password for later verification
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

      print('✅ User registered successfully!');
      _currentUser = AppUserDto.fromJson(userId, userData);
      return _currentUser!;
    } catch (e) {
      print('❌ Registration exception: $e');
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
