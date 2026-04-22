import 'package:flutter/material.dart';
import 'package:velotoulouse/data/repositories/station/station_repository.dart';
import 'package:velotoulouse/model/station/station.dart';
import 'package:velotoulouse/ui/states/view_state.dart';

class StationDetailViewModel extends ChangeNotifier {
  final StationRepository stationRepository;

  ViewState _state = ViewState.idle;
  Station? _station;
  String? _selectedSlotId;
  String? _errorMessage;
  String? _lastStationId;

  ViewState get state => _state;
  Station? get station => _station;
  String? get selectedSlotId => _selectedSlotId;
  String? get errorMessage => _errorMessage;

  StationDetailViewModel({required this.stationRepository});

  Future<void> loadStation(String stationId) async {
    _lastStationId = stationId;
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _station = await stationRepository.getStationById(stationId);
      _selectedSlotId = null;
      _state = ViewState.success;
    } catch (e) {
      _errorMessage = 'Failed to load station: $e';
      _state = ViewState.error;
    }

    notifyListeners();
  }

  Future<void> retry() async {
    if (_lastStationId == null || _lastStationId!.isEmpty) {
      return;
    }
    await loadStation(_lastStationId!);
  }

  void selectSlot(String slotId) {
    _selectedSlotId = slotId;
    _errorMessage = null;
    notifyListeners();
  }
}