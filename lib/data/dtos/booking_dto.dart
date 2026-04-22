import '../../model/booking/booking.dart';

class BookingDto {
  static const String idKey = 'id';
  static const String userIdKey = 'userId';
  static const String bikeSlotIdKey = 'bikeSlotId';
  static const String stationIdKey = 'stationId';
  static const String paymentIdKey = 'paymentId';
  static const String passIdKey = 'passId';
  static const String statusKey = 'status';
  static const String bookedAtKey = 'bookedAt';

  static Booking fromJson(String id, Map<String, dynamic> json) {
    final bookingId = json[idKey] as String?;
    final userId = json[userIdKey] as String?;
    final bikeSlotId = json[bikeSlotIdKey] as String?;
    final stationId = json[stationIdKey] as String?;
    final statusStr = json[statusKey] as String?;
    final bookedAtStr = json[bookedAtKey] as String?;

    assert(bookingId != null && bookingId.isNotEmpty, 'Booking missing id');
    assert(userId != null && userId.isNotEmpty, 'Booking $id missing userId');
    assert(bikeSlotId != null && bikeSlotId.isNotEmpty, 'Booking $id missing bikeSlotId');
    assert(stationId != null && stationId.isNotEmpty, 'Booking $id missing stationId');
    assert(statusStr != null && statusStr.isNotEmpty, 'Booking $id missing status');
    assert(bookedAtStr != null && bookedAtStr.isNotEmpty, 'Booking $id missing bookedAt');

    return Booking(
      id: bookingId!,
      userId: userId!,
      bikeSlotId: bikeSlotId!,
      stationId: stationId!,
      paymentId: json[paymentIdKey] as String?,
      passId: json[passIdKey] as String?,
      status: BookingStatus.values.byName(statusStr!),
      bookedAt: DateTime.parse(bookedAtStr!),
    );
  }

  /// Convert Booking to JSON
  static Map<String, dynamic> toJson(Booking booking) {
    return {
      idKey: booking.id,
      userIdKey: booking.userId,
      bikeSlotIdKey: booking.bikeSlotId,
      stationIdKey: booking.stationId,
      paymentIdKey: booking.paymentId,
      passIdKey: booking.passId,
      statusKey: booking.status.name,
      bookedAtKey: booking.bookedAt.toIso8601String(),
    };
  }
}
