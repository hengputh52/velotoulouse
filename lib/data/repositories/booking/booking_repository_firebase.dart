// lib/data/repositories/booking/booking_repository_firebase.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velotoulouse/data/dtos/booking_dto.dart';
import 'package:velotoulouse/data/repositories/booking/booking_repository.dart';
import 'package:velotoulouse/model/booking/booking.dart';

class FirebaseBookingRepository implements BookingRepository {
  final Uri bookingsUri = Uri.https(
    'velotoulouse-42876-default-rtdb.firebaseio.com',
    '/bookings.json',
  );

  @override
  Future<Booking> createBooking({
    required String userId,
    required String bikeSlotId,
    required String stationId,
    String? paymentId,
    String? passId,
  }) async {
    final slotCheckUri = Uri.https(
      'velotoulouse-42876-default-rtdb.firebaseio.com',
      '/slots/$bikeSlotId.json',
    );

    final slotResponse = await http.get(slotCheckUri);
    if (slotResponse.statusCode != 200) {
      throw Exception('Bike slot not found');
    }

    final slotData = json.decode(slotResponse.body);
    if (slotData == null) {
      throw Exception('Bike slot not found');
    }
    if (slotData['isAvailable'] != true) {
      throw Exception('Bike slot is not available');
    }

    final alreadyRiding = await hasCurrentBooking(userId);
    if (alreadyRiding) {
      throw Exception('Return your current bike before booking a new ride');
    }

    final bookingId = 'booking_${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now();

    final bookingData = {
      'id': bookingId,
      'userId': userId,
      'bikeSlotId': bikeSlotId,
      'stationId': stationId,
      'paymentId': paymentId,
      'passId': passId,
      'status': BookingStatus.confirmed.name,
      'bookedAt': now.toIso8601String(),
    };

    final postUri = Uri.https(
      'velotoulouse-42876-default-rtdb.firebaseio.com',
      '/bookings/$bookingId.json',
    );

    final bookingResponse = await http.put(
      postUri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(bookingData),
    );

    if (bookingResponse.statusCode != 200) {
      throw Exception(
        'Failed to create booking: ${bookingResponse.statusCode}',
      );
    }

    await http.patch(
      slotCheckUri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'isAvailable': false}),
    );

    return BookingDto.fromJson(bookingId, bookingData);
  }

  @override
  Future<Booking?> getActiveBooking(String userId) async {
    final response = await http.get(bookingsUri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load bookings: ${response.statusCode}');
    }
    if (response.body == 'null' || response.body.isEmpty) {
      return null;
    }

    final bookingsJson = json.decode(response.body) as Map<String, dynamic>;

    for (final entry in bookingsJson.entries) {
      if (entry.value is! Map<String, dynamic>) continue;
      try {
        final booking = BookingDto.fromJson(
          entry.key,
          entry.value as Map<String, dynamic>,
        );
        if (booking.userId == userId &&
            booking.status == BookingStatus.confirmed) {
          return booking;
        }
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  @override
  Future<List<Booking>> getBookingHistory(String userId) async {
    final response = await http.get(bookingsUri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load booking history: ${response.statusCode}');
    }

    if (response.body == 'null' || response.body.isEmpty) {
      return [];
    }

    final bookingsJson = json.decode(response.body) as Map<String, dynamic>;
    final result = <Booking>[];

    for (final entry in bookingsJson.entries) {
      if (entry.value is! Map<String, dynamic>) continue;
      try {
        final booking = BookingDto.fromJson(
          entry.key,
          entry.value as Map<String, dynamic>,
        );
        if (booking.userId == userId) {
          result.add(booking);
        }
      } catch (_) {
        continue;
      }
    }
    return result;
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    final cancelUri = Uri.https(
      'velotoulouse-42876-default-rtdb.firebaseio.com',
      '/bookings/$bookingId.json',
    );

    final response = await http.patch(
      cancelUri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'status': BookingStatus.cancelled.name}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to cancel booking: ${response.statusCode}');
    }
  }

  @override
  Future<bool> hasCurrentBooking(String userId) async {
    final response = await http.get(bookingsUri);

    if (response.statusCode != 200) {
      throw Exception('Failed to check booking status: ${response.statusCode}');
    }

    if (response.body == 'null' || response.body.isEmpty) {
      return false;
    }

    final decoded = json.decode(response.body);
    if (decoded is! Map<String, dynamic>) return false;

    for (final entry in decoded.entries) {
      if (entry.value is! Map<String, dynamic>) continue;
      try {
        final booking = BookingDto.fromJson(
          entry.key,
          entry.value as Map<String, dynamic>,
        );
        if (booking.userId == userId &&
            booking.status == BookingStatus.confirmed) {
          return true;
        }
      } catch (_) {
        continue;
      }
    }
    return false;
  }
}
