// lib/data/repositories/payment/payment_repository_firebase.dart

import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:velotoulouse/data/dtos/payment_dto.dart';
import 'package:velotoulouse/data/repositories/payment/payment_repository.dart';
import 'package:velotoulouse/model/payment/payment.dart';

class FirebasePaymentRepository implements PaymentRepository {
  final Uri paymentsUri = Uri.https(
    'velotoulouse-42876-default-rtdb.firebaseio.com',
    '/payments.json',
  );

  @override
  Future<Payment> processPayment({
    required String userId,
    required double amount,
    required PaymentMethod method,
    required PaymentPurpose purpose,
  }) async {
    try {
      final now = DateTime.now();
      final paymentId = 'payment_${DateTime.now().millisecondsSinceEpoch}';

      var paymentData = {
        'id': paymentId,
        'userId': userId,
        'amount': amount,
        'method': method.name,
        'status': PaymentStatus.pending.name,
        'purpose': purpose.name,
        'createdAt': now.toIso8601String(),
      };

      // Post payment to Firebase
      await http.post(
        Uri.https(
          'velotoulouse-42876-default-rtdb.firebaseio.com',
          '/payments/$paymentId.json',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(paymentData),
      );

      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 1));

      // Update status to success
      paymentData['status'] = PaymentStatus.success.name;
      await http.put(
        Uri.https(
          'velotoulouse-42876-default-rtdb.firebaseio.com',
          '/payments/$paymentId.json',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(paymentData),
      );

      return PaymentDto.fromJson(paymentData).toModel();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Payment>> getPaymentHistory(String userId) async {
    try {
      final http.Response response = await http.get(paymentsUri);

      if (response.statusCode == 200) {
        Map<String, dynamic> paymentsJson = json.decode(response.body);
        List<Payment> result = [];

        for (final entry in paymentsJson.entries) {
          final paymentDto = PaymentDto.fromJson(entry.value);
          final payment = paymentDto.toModel();

          if (payment.userId == userId) {
            result.add(payment);
          }
        }
        return result;
      } else {
        throw Exception('Failed to load payment history');
      }
    } catch (e) {
      rethrow;
    }
  }
}
