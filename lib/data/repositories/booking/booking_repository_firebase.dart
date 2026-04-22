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

  final Uri slotsUri = Uri.https(
    'velotoulouse-42876-default-rtdb.firebaseio.com',
    '/slots.json',
  );

  @override
  Future<Booking> createBooking({
    required String userId,
    required String bikeSlotId,
    required String stationId,
    String? paymentId,
    String? passId,
  }) async {
    try {
      // Check if slot is available
      final slotCheckUri = Uri.https(
        'velotoulouse-42876-default-rtdb.firebaseio.com',
        '/slots/$bikeSlotId.json',
      );

      final slotResponse = await http.get(slotCheckUri);
      if (slotResponse.statusCode != 200) {
        throw Exception('Bike slot not found');
      }

      final slotData = json.decode(slotResponse.body) as Map<String, dynamic>;
      if (slotData['isAvailable'] != true) {
        throw Exception('Bike slot is not available');
      }

      // Create booking
      final now = DateTime.now();
      final bookingId = 'booking_${DateTime.now().millisecondsSinceEpoch}';

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

      await http.post(
        Uri.https(
          'velotoulouse-42876-default-rtdb.firebaseio.com',
          '/bookings/$bookingId.json',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(bookingData),
      );

      // Update slot availability
      await http.patch(
        slotCheckUri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'isAvailable': false}),
      );

      return BookingDto.fromJson(bookingId, bookingData);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Booking?> getActiveBooking(String userId) async {
    try {
      final http.Response response = await http.get(bookingsUri);

      if (response.statusCode == 200) {
        if (response.body == 'null' || response.body.isEmpty) {
          return null;
        }

        Map<String, dynamic> bookingsJson = json.decode(response.body);

        for (final entry in bookingsJson.entries) {
          try {
            final booking = BookingDto.fromJson(entry.key, entry.value as Map<String, dynamic>);

            if (booking.userId == userId && booking.status == BookingStatus.confirmed) {
              return booking;
            }
          } catch (e) {
            print('⚠️ Skipping malformed booking ${entry.key}: $e');
            continue;
          }
        }
        return null;
      } else {
        throw Exception('Failed to load bookings: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error loading active booking: $e');
      rethrow;
    }
  }

  @override
  Future<List<Booking>> getBookingHistory(String userId) async {
    try {
      final http.Response response = await http.get(bookingsUri);

      if (response.statusCode == 200) {
        if (response.body == 'null' || response.body.isEmpty) {
          return [];
        }

        Map<String, dynamic> bookingsJson = json.decode(response.body);
        List<Booking> result = [];

        for (final entry in bookingsJson.entries) {
          try {
            final booking = BookingDto.fromJson(entry.key, entry.value as Map<String, dynamic>);

            if (booking.userId == userId) {
              result.add(booking);
            }
          } catch (e) {
            print('⚠️ Skipping malformed booking ${entry.key}: $e');
            continue;
          }
        }
        return result;
      } else {
        throw Exception('Failed to load booking history: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error loading booking history: $e');
      rethrow;
    }
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    try {
      final Uri cancelUri = Uri.https(
        'velotoulouse-42876-default-rtdb.firebaseio.com',
        '/bookings/$bookingId.json',
      );

      await http.patch(
        cancelUri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'status': BookingStatus.cancelled.name}),
      );
    } catch (e) {
      rethrow;
    }
  }
}
