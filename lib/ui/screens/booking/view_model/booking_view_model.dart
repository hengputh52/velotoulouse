import 'package:flutter/material.dart';
import 'package:velotoulouse/data/repositories/booking/booking_repository.dart';
import 'package:velotoulouse/data/repositories/pass/pass_repository.dart';
import 'package:velotoulouse/data/repositories/station/station_repository.dart';
import 'package:velotoulouse/model/booking/booking.dart';
import 'package:velotoulouse/model/pass/pass.dart';
import 'package:velotoulouse/model/station/station.dart';
import 'package:velotoulouse/ui/states/view_state.dart';

class BookingViewModel extends ChangeNotifier {
  final BookingRepository bookingRepository;
  final PassRepository passRepository;
  final StationRepository stationRepository;

  ViewState _state = ViewState.idle;
  Booking? _currentBooking;
  Pass? _activePass;
  Station? _currentStation;
  String? _errorMessage;

  ViewState get state => _state;
  Booking? get currentBooking => _currentBooking;
  Pass? get activePass => _activePass;
  bool get hasActivePass => _activePass != null && _activePass!.isActive;
  Station? get currentStation => _currentStation;
  String? get errorMessage => _errorMessage;

  BookingViewModel(
    this.bookingRepository,
    this.passRepository,
    this.stationRepository,
  );

  // Load active pass for user
  Future<void> loadActivePass(String userId) async {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _activePass = await passRepository.getActivePass(userId);
      _state = ViewState.success;
    } catch (e) {
      _errorMessage = 'Failed to load active pass: ${e.toString()}';
      _state = ViewState.error;
    }
    notifyListeners();
  }

  // Load station details
  Future<void> loadStation(String stationId) async {
    try {
      _currentStation = await stationRepository.getStationById(stationId);
    } catch (e) {
      _errorMessage = 'Failed to load station: ${e.toString()}';
    }
    notifyListeners();
  }

  // Confirm booking with either pass or payment
  Future<void> confirmBooking({
    required String userId,
    required String bikeSlotId,
    required String stationId,
    String? paymentId,
    String? passId,
  }) async {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Validate: exactly one of paymentId or passId
      if ((paymentId != null && passId != null) ||
          (paymentId == null && passId == null)) {
        throw Exception(
          'Must provide either paymentId or passId, but not both',
        );
      }

      _currentBooking = await bookingRepository.createBooking(
        userId: userId,
        bikeSlotId: bikeSlotId,
        stationId: stationId,
        paymentId: paymentId,
        passId: passId,
      );

      _state = ViewState.success;
    } catch (e) {
      _errorMessage = 'Booking failed: ${e.toString()}';
      _state = ViewState.error;
    }
    notifyListeners();
  }

  // Cancel active booking
  Future<void> cancelBooking(String bookingId) async {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await bookingRepository.cancelBooking(bookingId);
      _currentBooking = null;
      _state = ViewState.success;
    } catch (e) {
      _errorMessage = 'Cancellation failed: ${e.toString()}';
      _state = ViewState.error;
    }
    notifyListeners();
  }

  // Reset view model
  void reset() {
    _state = ViewState.idle;
    _currentBooking = null;
    _errorMessage = null;
    notifyListeners();
  }
}
