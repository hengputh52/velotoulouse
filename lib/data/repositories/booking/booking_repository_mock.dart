import 'package:velotoulouse/data/repositories/booking/booking_repository.dart';
import 'package:velotoulouse/model/booking/booking.dart';

class MockBookingRepository implements BookingRepository {
  // In-memory storage for bookings
  final Map<String, Booking> _bookings = {};
  final Map<String, List<Booking>> _userBookings = {};

  @override
  Future<Booking> createBooking({
    required String userId,
    required String bikeSlotId,
    required String stationId,
    String? paymentId,
    String? passId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final booking = Booking(
      id: 'booking_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      bikeSlotId: bikeSlotId,
      stationId: stationId,
      paymentId: paymentId,
      passId: passId,
      status: BookingStatus.confirmed,
      bookedAt: DateTime.now(),
    );

    // Store booking in memory
    _bookings[booking.id] = booking;
    _userBookings.putIfAbsent(userId, () => []).add(booking);

    return booking;
  }

  @override
  Future<Booking?> getActiveBooking(String userId) async {
    await Future.delayed(const Duration(milliseconds: 600));

    // Return the first confirmed booking for this user
    try {
      return (_userBookings[userId] ?? []).firstWhere(
        (b) => b.status == BookingStatus.confirmed,
      );
    } catch (e) {
      return null; // No active booking
    }
  }

  @override
  Future<List<Booking>> getBookingHistory(String userId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _userBookings[userId] ?? [];
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final booking = _bookings[bookingId];
    if (booking != null) {
      _bookings[bookingId] = Booking(
        id: booking.id,
        userId: booking.userId,
        bikeSlotId: booking.bikeSlotId,
        stationId: booking.stationId,
        paymentId: booking.paymentId,
        passId: booking.passId,
        status: BookingStatus.cancelled,
        bookedAt: booking.bookedAt,
      );
    }
  }

  @override
  Future<void> completeBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final booking = _bookings[bookingId];
    if (booking != null) {
      _bookings[bookingId] = Booking(
        id: booking.id,
        userId: booking.userId,
        bikeSlotId: booking.bikeSlotId,
        stationId: booking.stationId,
        paymentId: booking.paymentId,
        passId: booking.passId,
        status: BookingStatus.completed,
        bookedAt: booking.bookedAt,
      );
    }
  }
}
