import 'dart:async';

import 'package:velotoulouse/data/repositories/booking/booking_repository.dart';
import 'package:velotoulouse/model/booking/booking.dart';
import 'package:velotoulouse/ui/states/active_booking_state.dart';

class ActiveBookingViewModel {
  final BookingRepository _bookingRepository;
  final ActiveBookingState _state;
  Timer? _timer;

  ActiveBookingViewModel(this._bookingRepository, this._state);

  Booking? get activeBooking => _state.activeBooking;
  String? get stationName => _state.stationName;

  String formatBookingTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final hh = local.hour.toString().padLeft(2, '0');
    final mm = local.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  Future<void> loadActiveBooking(String userId) async {
    final booking = await _bookingRepository.getActiveBooking(userId);
    if (booking == null) {
      clearBooking();
      return;
    }

    _state.setActiveBooking(booking);
    _startTimerFrom(booking.bookedAt);
  }

  void setActiveBooking(Booking? booking, {String? stationName}) {
    if (booking == null) {
      clearBooking();
      return;
    }

    _state.setActiveBooking(booking, stationName: stationName);
    _startTimerFrom(booking.bookedAt);
  }

  void clearBooking() {
    _stopTimer();
    _state.clear();
  }

  void _startTimerFrom(DateTime bookedAt) {
    _stopTimer();
    final initial = DateTime.now().difference(bookedAt).inSeconds;
    _state.setElapsedSeconds(initial < 0 ? 0 : initial);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _state.setElapsedSeconds(_state.elapsedSeconds + 1);
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  String currentRideTimeFormat() {
    final currentTime = _state.elapsedSeconds;
    final second = currentTime % 60;
    final minute = (currentTime % 3600) ~/ 60;
    final hour = currentTime ~/ 3600;

    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    final s = second.toString().padLeft(2, '0');

    return "$h:$m:$s";
  }

  void dispose() {
    _stopTimer();
  }
}
