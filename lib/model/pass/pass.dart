enum PassType { dayPass, monthlyPass, annualPass }

class Pass {
  final String id;
  final String userId;
  final String paymentId;
  final PassType type;
  final DateTime purchasedAt;
  final DateTime expiresAt;

  const Pass({
    required this.id,
    required this.userId,
    required this.paymentId,
    required this.type,
    required this.purchasedAt,
    required this.expiresAt,
  });

  bool get isActive => DateTime.now().isBefore(expiresAt);

  Duration get validityDuration {
    switch (type) {
      case PassType.dayPass:
        return const Duration(days: 1);
      case PassType.monthlyPass:
        return const Duration(days: 30);
      case PassType.annualPass:
        return const Duration(days: 365);
    }
  }

  
}
