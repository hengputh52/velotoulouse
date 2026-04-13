import 'package:velotoulouse/data/repositories/pass/pass_repository.dart';
import 'package:velotoulouse/model/pass/pass.dart';

class MockPassRepository implements PassRepository {
  @override
  Future<Pass?> getActivePass(String userId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return Pass(
      id: 'pass_1',
      userId: userId,
      paymentId: 'payment_1',
      type: PassType.monthly,
      purchasedAt: DateTime.now().subtract(const Duration(days: 10)),
      expiresAt: DateTime.now().add(const Duration(days: 20)),
    );
  }

  @override
  Future<List<Pass>> getPassHistory(String userId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      Pass(
        id: 'pass_1',
        userId: userId,
        paymentId: 'payment_1',
        type: PassType.monthly,
        purchasedAt: DateTime.now().subtract(const Duration(days: 10)),
        expiresAt: DateTime.now().add(const Duration(days: 20)),
      ),
      Pass(
        id: 'pass_2',
        userId: userId,
        paymentId: 'payment_2',
        type: PassType.day,
        purchasedAt: DateTime.now().subtract(const Duration(days: 50)),
        expiresAt: DateTime.now().subtract(const Duration(days: 49)),
      ),
    ];
  }

  @override
  Future<Pass> purchasePass(
    String userId,
    PassType type,
    String paymentId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final now = DateTime.now();
    final Duration validity = switch (type) {
      PassType.day => const Duration(days: 1),
      PassType.monthly => const Duration(days: 30),
      PassType.annual => const Duration(days: 365),
    };

    return Pass(
      id: 'pass_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      paymentId: paymentId,
      type: type,
      purchasedAt: now,
      expiresAt: now.add(validity),
    );
  }
}
