import 'package:flutter/material.dart';
import 'package:velotoulouse/model/booking/booking.dart';

class ActiveBookingState extends ChangeNotifier {
  Booking? _activeBooking;
  String? _stationName;
  int _elapsedSeconds = 0;

  Booking? get activeBooking => _activeBooking;
  String? get stationName => _stationName;
  int get elapsedSeconds => _elapsedSeconds;

  void setActiveBooking(Booking? booking, {String? stationName}) {
    _activeBooking = booking;
    _stationName = stationName;
    notifyListeners();
  }

  void setElapsedSeconds(int seconds) {
    _elapsedSeconds = seconds;
    notifyListeners();
  }

  void clear() {
    _activeBooking = null;
    _stationName = null;
    _elapsedSeconds = 0;
    notifyListeners();
  }
}
