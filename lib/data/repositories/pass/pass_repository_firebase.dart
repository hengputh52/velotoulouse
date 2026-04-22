import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velotoulouse/data/dtos/pass_dto.dart';
import 'package:velotoulouse/data/repositories/pass/pass_repository.dart';
import 'package:velotoulouse/model/pass/pass.dart';

class FirebasePassRepository implements PassRepository {
  final Uri passesUri = Uri.https(
    'velotoulouse-42876-default-rtdb.firebaseio.com',
    '/passes.json',
  );

  @override
  Future<Pass?> getActivePass(String userId) async {
    Pass? lastedPass;
    try {
      final http.Response response = await http.get(passesUri);
      if (response.statusCode == 200) {
        if (response.body == 'null' || response.body.isEmpty) {
          print('✓ No active pass found for user');
          return null;
        }
        Map<String, dynamic> passesJson = json.decode(response.body);

        for (final entry in passesJson.entries) {
          try {
            final pass = PassDto.fromJson(
              entry.key,
              entry.value as Map<String, dynamic>,
            );

            if (pass.userId == userId && pass.isActive) {
              lastedPass = pass;
            }
          } catch (e) {
            print('⚠️ Skipping malformed pass ${entry.key}: $e');
            continue;
          }
        }
      } else {
        throw Exception('No Active Pass Found: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error loading active pass: $e');
      rethrow;
    }
    return lastedPass;
  }

  @override
  Future<List<Pass>> getPassHistory(String userId) async {
    try {
      final http.Response response = await http.get(passesUri);

      if (response.statusCode == 200) {
        if (response.body == 'null' || response.body.isEmpty) {
          return [];
        }

        Map<String, dynamic> passesJson = json.decode(response.body);
        List<Pass> result = [];

        for (final entry in passesJson.entries) {
          try {
            final pass = PassDto.fromJson(
              entry.key,
              entry.value as Map<String, dynamic>,
            );

            if (pass.userId == userId) {
              result.add(pass);
            }
          } catch (e) {
            print('⚠️ Skipping malformed pass ${entry.key}: $e');
            continue;
          }
        }
        return result;
      } else {
        throw Exception('Failed to load pass history: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error loading pass history: $e');
      rethrow;
    }
  }

  @override
  Future<Pass> purchasePass(
    String userId,
    PassType type,
    String paymentId,
  ) async {
    try {
      final now = DateTime.now();
      final Duration validity = switch (type) {
        PassType.single => const Duration(minutes: 30),
        PassType.day => const Duration(days: 1),
        PassType.monthly => const Duration(days: 30),
        PassType.annual => const Duration(days: 365),
      };

      final passId = 'pass_${DateTime.now().millisecondsSinceEpoch}';
      final passData = {
        'id': passId,
        'userId': userId,
        'paymentId': paymentId,
        'type': type.name,
        'purchasedAt': now.toIso8601String(),
        'expiresAt': now.add(validity).toIso8601String(),
      };

      await http.put(
        Uri.https(
          'velotoulouse-42876-default-rtdb.firebaseio.com',
          '/passes/$passId.json',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(passData),
      );

      return PassDto.fromJson(passId, passData);
    } catch (e) {
      throw Exception('Error purchasing pass: $e');
    }
  }
}
