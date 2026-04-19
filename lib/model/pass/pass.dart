enum PassType {
  single('30 min', 'Valid for 30 minutes from activation', 2.00),
  day('24h', 'Valid for 24 hours from activation', 5.00),
  monthly('30 days', 'Valid for 30 days from activation', 15.00),
  annual('1 year', 'Valid for 365 days from activation', 99.00);

  final String duration;
  final String description;
  final double price;

  const PassType(this.duration, this.description, this.price);
}

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
      case PassType.single:
        return const Duration(minutes: 30);
      case PassType.day:
        return const Duration(days: 1);
      case PassType.monthly:
        return const Duration(days: 30);
      case PassType.annual:
        return const Duration(days: 365);
    }
  }


}
