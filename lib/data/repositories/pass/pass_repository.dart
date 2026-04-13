import 'package:velotoulouse/model/pass/pass.dart';

abstract class PassRepository {
  Future<Pass?> getActivePass(String userId);

  Future<List<Pass>> getPassHistory(String userId);

  Future<Pass> purchasePass(String userId, PassType type, String paymentId);
}
