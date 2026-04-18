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
    assert(json[idKey] is String);
    assert(json[userIdKey] is String);
    assert(json[bikeSlotIdKey] is String);
    assert(json[stationIdKey] is String);
    assert(json[statusKey] is String);
    assert(json[bookedAtKey] is String);

    return Booking(
      id: json[idKey],
      userId: json[userIdKey],
      bikeSlotId: json[bikeSlotIdKey],
      stationId: json[stationIdKey],
      paymentId: json[paymentIdKey] as String?,
      passId: json[passIdKey] as String?,
      status: BookingStatus.values.byName(json[statusKey]),
      bookedAt: DateTime.parse(json[bookedAtKey]),
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
