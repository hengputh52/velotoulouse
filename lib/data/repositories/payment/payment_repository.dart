import 'package:velotoulouse/model/payment/payment.dart';

abstract class PaymentRepository {
  Future<Payment> processPayment({
    required String userId,
    required double amount,
    required PaymentMethod method,
    required PaymentPurpose purpose,
  });

  Future<List<Payment>> getPaymentHistory(String userId);
}
