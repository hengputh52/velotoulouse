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


  bool? _hasCurrentRide;

  ViewState get state => _state;
  Booking? get currentBooking => _currentBooking;
  Pass? get activePass => _activePass;
  Station? get currentStation => _currentStation;
  String? get errorMessage => _errorMessage;

  bool get hasActivePass => _activePass != null && _activePass!.isActive;
  bool get currentRide => _hasCurrentRide == true;
  bool get rideCheckPending => _hasCurrentRide == null;

  BookingViewModel(
    this.bookingRepository,
    this.passRepository,
    this.stationRepository,
  );

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

  Future<void> loadStation(String stationId) async {
    try {
      _currentStation = await stationRepository.getStationById(stationId);
    } catch (e) {
      _errorMessage = 'Failed to load station: ${e.toString()}';
    }
    notifyListeners();
  }

  Future<void> loadCurrentRideStatus(String userId) async {
    try {
      _hasCurrentRide = await bookingRepository.hasCurrentBooking(userId);
    } catch (e) {
      _errorMessage = 'Failed to check current ride: ${e.toString()}';
      _hasCurrentRide = false;
    }
    notifyListeners();
  }

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
      if ((paymentId != null && passId != null) ||
          (paymentId == null && passId == null)) {
        throw Exception('Must provide either paymentId or passId, not both');
      }

      final alreadyRiding = await bookingRepository.hasCurrentBooking(userId);
      if (alreadyRiding) {
        throw Exception('Return your current bike before booking a new ride');
      }

      _currentBooking = await bookingRepository.createBooking(
        userId: userId,
        bikeSlotId: bikeSlotId,
        stationId: stationId,
        paymentId: paymentId,
        passId: passId,
      );

      _hasCurrentRide = true;
      _state = ViewState.success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = ViewState.error;
    }
    notifyListeners();
  }

  Future<void> cancelBooking(String bookingId) async {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await bookingRepository.cancelBooking(bookingId);
      _currentBooking = null;
      _hasCurrentRide = false;
      _state = ViewState.success;
    } catch (e) {
      _errorMessage = 'Cancellation failed: ${e.toString()}';
      _state = ViewState.error;
    }
    notifyListeners();
  }

  void reset() {
    _state = ViewState.idle;
    _currentBooking = null;
    _errorMessage = null;
    _hasCurrentRide = null;
    notifyListeners();
  }
}
