enum PassType { day, monthly, annual }

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

  int get daysLeft {
    if (!isActive) return 0;
    return expiresAt.difference(DateTime.now()).inDays + 1;
  }

  Duration get validityDuration {
    switch (type) {
      case PassType.day:
        return const Duration(days: 1);
      case PassType.monthly:
        return const Duration(days: 30);
      case PassType.annual:
        return const Duration(days: 365);
    }
  }


}
