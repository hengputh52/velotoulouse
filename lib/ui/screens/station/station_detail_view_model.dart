import 'package:flutter/material.dart';
import 'package:velotoulouse/data/repositories/station/station_repository.dart';
import 'package:velotoulouse/model/station/station.dart';
import 'package:velotoulouse/ui/states/view_state.dart';

class StationDetailViewModel extends ChangeNotifier {
  final StationRepository _stationRepository;

  ViewState _state = ViewState.loading;
  Station? _station;
  String? _errorMessage;
  String? _selectedSlotId;

  ViewState get state => _state;
  Station? get station => _station;
  String? get errorMessage => _errorMessage;
  String? get selectedSlotId => _selectedSlotId;

  StationDetailViewModel(this._stationRepository);

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
    }
  }

  // Clear selection
  void clearSelection() {
    _selectedSlotId = null;
    notifyListeners();
  }
}
