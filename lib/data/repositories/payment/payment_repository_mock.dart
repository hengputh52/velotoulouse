import 'package:velotoulouse/data/repositories/payment/payment_repository.dart';
import 'package:velotoulouse/model/payment/payment.dart';

class MockPaymentRepository implements PaymentRepository {
  @override
  Future<Payment> processPayment({
    required String userId,
    required double amount,
    required PaymentMethod method,
    required PaymentPurpose purpose,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return Payment(
      id: 'payment_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      amount: amount,
      method: method,
      status: PaymentStatus.success,
      purpose: purpose,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<List<Payment>> getPaymentHistory(String userId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      Payment(
        id: 'payment_1',
        userId: userId,
        amount: 15.0,
        method: PaymentMethod.card,
        status: PaymentStatus.success,
        purpose: PaymentPurpose.monthlyPass,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      Payment(
        id: 'payment_2',
        userId: userId,
        amount: 2.0,
        method: PaymentMethod.mobileMoney,
        status: PaymentStatus.success,
        purpose: PaymentPurpose.singleTicket,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }
}
