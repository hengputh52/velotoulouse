import 'package:flutter/material.dart';
import 'package:velotoulouse/data/repositories/booking/booking_repository.dart';
import 'package:velotoulouse/data/repositories/station/station_repository.dart';
import 'package:velotoulouse/model/station/station.dart';
import 'package:velotoulouse/ui/states/view_state.dart';

class StationDetailViewModel extends ChangeNotifier {
  final StationRepository _stationRepository;
  final BookingRepository _bookingRepository;

  ViewState _state = ViewState.loading;
  Station? _station;
  String? _errorMessage;
  String? _selectedSlotId;

  // Cache for slot statuses (slotId -> status: 'available'/'booked'/'empty'/'maintenance')
  final Map<String, String> _slotStatuses = {};

  ViewState get state => _state;
  Station? get station => _station;
  String? get errorMessage => _errorMessage;
  String? get selectedSlotId => _selectedSlotId;

  StationDetailViewModel(this._stationRepository, this._bookingRepository);

  // Load station data
  Future<void> loadStation(String stationId) async {
    _state = ViewState.loading;
    _errorMessage = null;
    _selectedSlotId = null;
    notifyListeners();

    try {
      _station = await _stationRepository.getStationById(stationId);
      if (_station == null) {
        _errorMessage = 'Station not found';
        _state = ViewState.error;
      } else {
        _state = ViewState.success;
      }
    } catch (e) {
      _errorMessage = 'Failed to load station: ${e.toString()}';
      _state = ViewState.error;
    }

    notifyListeners();
  }

  // Select a bike slot
  void selectSlot(String slotId) {
    final slot = _station?.slots.firstWhere(
      (s) => s.id == slotId,
      orElse: () => throw Exception('Slot not found'),
    );

    if (slot != null && slot.isAvailable) {
      _selectedSlotId = slotId;
      notifyListeners();
    } else {
      _errorMessage = 'Cannot book this bike - it is not available';
      notifyListeners();
    }
  }

  // Clear selection
  void clearSelection() {
    _selectedSlotId = null;
    notifyListeners();
  }

  // Retry loading station
  Future<void> retry(String stationId) async {
    await loadStation(stationId);
  }

  /// Get the display status for a bike slot
  /// Returns: 'available', 'booked', 'empty', or 'maintenance'
  Future<String> getSlotStatus(String slotId, String userId) async {
    // Check cache first
    if (_slotStatuses.containsKey(slotId)) {
      return _slotStatuses[slotId]!;
    }

    // If slot is available, status is 'available'
    final slot = _station?.slots.firstWhere(
      (s) => s.id == slotId,
      orElse: () =>
          BikeSlot(id: '', stationId: '', slotNumber: 0, isAvailable: false),
    );

    if (slot != null && slot.isAvailable) {
      _slotStatuses[slotId] = 'available';
      return 'available';
    }

    // If not available, check if there's an active booking for this slot
    try {
      final bookings = await _bookingRepository.getBookingHistory(userId);
      final activeBooking = bookings.firstWhere(
        (b) => b.bikeSlotId == slotId && b.isActive,
        orElse: () => throw Exception('No active booking'),
      );

      // There's an active booking for this slot
      _slotStatuses[slotId] = 'booked';
      return 'booked';
    } catch (e) {
      // No active booking, it's either empty or maintenance
      // For now, default to 'empty'. In future, add maintenance flag to model
      _slotStatuses[slotId] = 'empty';
      return 'empty';
    }
  }

  /// Clear cached status for a slot (call after booking/return)
  void clearSlotStatusCache(String slotId) {
    _slotStatuses.remove(slotId);
  }

  /// Clear all cached statuses
  void clearAllStatusCache() {
    _slotStatuses.clear();
  }
}
