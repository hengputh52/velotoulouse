import 'package:velotoulouse/model/booking/booking.dart';


class BookingDto {
  final String id;
  final String userId;
  final String bikeSlotId;
  final String stationId;
  final String? paymentId;
  final String? passId;
  final String status;
  final DateTime bookedAt;

  const BookingDto({
    required this.id,
    required this.userId,
    required this.bikeSlotId,
    required this.stationId,
    this.paymentId,
    this.passId,
    required this.status,
    required this.bookedAt,
  });

  factory BookingDto.fromJson(Map<String, dynamic> json) {
    return BookingDto(
      id: json['id'] as String,
      userId: json['userId'] as String,
      bikeSlotId: json['bikeSlotId'] as String,
      stationId: json['stationId'] as String,
      paymentId: json['paymentId'] as String?,
      passId: json['passId'] as String?,
      status: json['status'] as String,
      bookedAt: _parseDateTime(json['bookedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'bikeSlotId': bikeSlotId,
      'stationId': stationId,
      'paymentId': paymentId,
      'passId': passId,
      'status': status,
      'bookedAt': bookedAt.toIso8601String(),
    };
  }

  Booking toModel() {
    return Booking(
      id: id,
      userId: userId,
      bikeSlotId: bikeSlotId,
      stationId: stationId,
      paymentId: paymentId,
      passId: passId,
      status: BookingStatus.values.byName(status),
      bookedAt: bookedAt,
    );
  }

  factory BookingDto.fromModel(Booking model) {
    return BookingDto(
      id: model.id,
      userId: model.userId,
      bikeSlotId: model.bikeSlotId,
      stationId: model.stationId,
      paymentId: model.paymentId,
      passId: model.passId,
      status: model.status.name,
      bookedAt: model.bookedAt,
    );
  }

  static DateTime _parseDateTime(dynamic data) {
    if (data == null) return DateTime.now();
    if (data is DateTime) return data;
    if (data is String) return DateTime.parse(data);
    if (data is Map && data['_seconds'] != null) {
      return DateTime.fromMillisecondsSinceEpoch(
        (data['_seconds'] as int) * 1000,
      );
    }
    return DateTime.now();
  }
}
