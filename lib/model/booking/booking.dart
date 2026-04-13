enum BookingStatus { confirmed, cancelled, completed }

class Booking {
  final String id;
  final String userId;
  final String bikeSlotId;
  final String stationId;
  final String? paymentId;
  final String? passId;
  final BookingStatus status;
  final DateTime bookedAt;

  const Booking({
    required this.id,
    required this.userId,
    required this.bikeSlotId,
    required this.stationId,
    this.paymentId,
    this.passId,
    required this.status,
    required this.bookedAt,
  });

  bool get paidByPass => passId != null;
  bool get paidByTicket => paymentId != null && passId == null;

  bool get isActive {
    return status == BookingStatus.confirmed;
  }

}
