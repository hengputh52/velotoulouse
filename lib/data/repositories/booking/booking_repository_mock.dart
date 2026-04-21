import 'package:velotoulouse/data/repositories/booking/booking_repository.dart';
import 'package:velotoulouse/model/booking/booking.dart';


class MockBookingRepository implements BookingRepository {
  @override
  Future<Booking> createBooking({
    required String userId,
    required String bikeSlotId,
    required String stationId,
    String? paymentId,
    String? passId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return Booking(
      id: 'booking_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      bikeSlotId: bikeSlotId,
      stationId: stationId,
      paymentId: paymentId,
      passId: passId,
      status: BookingStatus.confirmed,
      bookedAt: DateTime.now(),
    );
  }

  @override
  Future<Booking?> getActiveBooking(String userId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return Booking(
      id: 'booking_1',
      userId: userId,
      bikeSlotId: 'slot_1',
      stationId: 'station_1',
      paymentId: null,
      passId: 'pass_1',
      status: BookingStatus.confirmed,
      bookedAt: DateTime.now(),
    );
  }

  @override
  Future<List<Booking>> getBookingHistory(String userId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      Booking(
        id: 'booking_1',
        userId: userId,
        bikeSlotId: 'slot_1',
        stationId: 'station_1',
        paymentId: null,
        passId: 'pass_1',
        status: BookingStatus.confirmed,
        bookedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Booking(
        id: 'booking_2',
        userId: userId,
        bikeSlotId: 'slot_2',
        stationId: 'station_2',
        paymentId: 'payment_1',
        passId: null,
        status: BookingStatus.completed,
        bookedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 600));
  }
}
