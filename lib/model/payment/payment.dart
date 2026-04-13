enum PaymentStatus { pending, success, failed }
enum PaymentMethod { card, mobileMoney, cash }
enum PaymentPurpose { singleTicket, dayPass, monthlyPass, annualPass }

class Payment {
  final String id;
  final String userId;
  final double amount;
  final PaymentMethod method;
  final PaymentStatus status;
  final PaymentPurpose purpose;
  final DateTime createdAt;

  const Payment({
    required this.id,
    required this.userId,
    required this.amount,
    required this.method,
    required this.status,
    required this.purpose,
    required this.createdAt,
  });

  bool get isForPass =>
      purpose == PaymentPurpose.dayPass ||
      purpose == PaymentPurpose.monthlyPass ||
      purpose == PaymentPurpose.annualPass;

  bool get isSuccessful => status == PaymentStatus.success;

}
