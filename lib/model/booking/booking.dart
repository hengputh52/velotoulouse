enum BookingStatus { pending, confirmed, cancelled, completed }

class Booking {
  final String id;
  final String userId;
  final String stationId;
  final String slotId;
  final String? bikeId;
  final String? paymentId;
  final String? passId;
  final BookingStatus status;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final DateTime? completedAt;

  const Booking({
    required this.id,
    required this.userId,
    required this.stationId,
    required this.slotId,
    this.bikeId,
    this.paymentId,
    this.passId,
    required this.status
    ,
    required this.createdAt,
    this.confirmedAt,
    this.completedAt,
  });

  bool get isActive {
    return status == BookingStatus.pending || status == BookingStatus.confirmed;
  }

 
}
