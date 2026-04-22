import 'package:velotoulouse/model/booking/booking.dart';

abstract class BookingRepository {
  Future<Booking> createBooking({
    required String userId,
    required String bikeSlotId,
    required String stationId,
    String? paymentId,
    String? passId,
  });

  Future<Booking?> getActiveBooking(String userId);

  Future<List<Booking>> getBookingHistory(String userId);

  Future<void> cancelBooking(String bookingId);

  Future<void> completeBooking(String bookingId);
}
