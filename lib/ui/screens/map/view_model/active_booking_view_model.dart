import 'package:flutter/material.dart';
import 'package:velotoulouse/model/booking/booking.dart';

class ActiveBookingViewModel extends ChangeNotifier {
  Booking? _activeBooking;
  String? _stationName;

  Booking? get activeBooking => _activeBooking;
  String? get stationName => _stationName;

  void setActiveBooking(Booking? booking, {String? stationName}) {
    _activeBooking = booking;
    _stationName = stationName;
    notifyListeners();
  }

  void clearBooking() {
    _activeBooking = null;
    _stationName = null;
    notifyListeners();
  }
}
