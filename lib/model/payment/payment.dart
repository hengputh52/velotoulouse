enum PaymentStatus { pending, success, failed }
enum PaymentMethod { card, mobileMoney, cash }
enum PurchaseType { singleTicket, dayPass, monthlyPass, annualPass }

class Payment {
  final String id;
  final String userId;
  final double amount;
  final PurchaseType purchaseType;
  final PaymentStatus status;
  final PaymentMethod method;
  final DateTime createdAt;
  final DateTime? completedAt;

  const Payment({
    required this.id,
    required this.userId,
    required this.amount,
    required this.purchaseType,
    required this.status,
    required this.method,
    required this.createdAt,
    this.completedAt,
  });

  bool get isSuccessful => status == PaymentStatus.success;

  }
