import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:velotoulouse/data/repositories/station/station_repository.dart';
import 'package:velotoulouse/model/location/location.dart';
import 'package:velotoulouse/model/station/station.dart';
import 'package:velotoulouse/ui/utils/async_value.dart';

class StationViewModel extends ChangeNotifier {
  final StationRepository stationRepository;

  AsyncValue<List<Station>> stationsValue = AsyncValue.loading();

  Station? selectedStation;

  Location? _userLocation;
  Location? get userLocation => _userLocation;

  bool _isLocating = false;
  bool get isLocating => _isLocating;

  List<Station>? _filteredStations;
  String _searchQuery = '';

  List<Station>? get filteredStations => _filteredStations;
  String get searchQuery => _searchQuery;

  StationViewModel({required this.stationRepository}) {
    _init();
  }

  void _init() async {
    await fetchStations();
    await fetchUserLocation();
  }

  Future<void> refreshAfterBooking() async {
    try {
      final List<Station> stations = await stationRepository.getStations();
      final sorted = _sortByDistance(stations);
      stationsValue = AsyncValue.success(sorted);

      if (_searchQuery.isNotEmpty) {
        _filteredStations = _applyFilter(sorted, _searchQuery);
      } else {
        _filteredStations = null;
      }
    } catch (e) {
      debugPrint('Background station refresh failed: $e');
    }
    notifyListeners();
  }

  void searchStations(String query) {
    _searchQuery = query;

    if (!stationsValue.isSuccess || stationsValue.data == null) {
      _filteredStations = null;
      notifyListeners();
      return;
    }

    if (query.isEmpty) {
      _filteredStations = null;
    } else {
      _filteredStations = _applyFilter(stationsValue.data!, query);
    }

    notifyListeners();
  }

  List<Station> _applyFilter(List<Station> stations, String query) {
    final q = query.toUpperCase();
    final filtered = stations
        .where(
          (s) =>
              s.name.toUpperCase().contains(q) ||
              (s.address?.toUpperCase().contains(q) ?? false),
        )
        .toList();
    return _sortByDistance(filtered);
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredStations = null;
    notifyListeners();
  }

  Future<void> fetchStations() async {
    stationsValue = AsyncValue.loading();
    notifyListeners();

    try {
      final List<Station> stations = await stationRepository.getStations();
      stationsValue = AsyncValue.success(_sortByDistance(stations));
    } catch (e) {
      stationsValue = AsyncValue.error(e);
    }
    notifyListeners();
  }

  void selectStation(Station station) {
    selectedStation = station;
    notifyListeners();
  }

  void clearSelectedStation() {
    selectedStation = null;
    notifyListeners();
  }

  Future<void> fetchUserLocation() async {
    _isLocating = true;
    notifyListeners();

    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        _isLocating = false;
        notifyListeners();
        return;
      }

      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        _isLocating = false;
        notifyListeners();
        return;
      }

      final Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _userLocation = Location(
        id: 'user_location',
        latitude: pos.latitude,
        longitude: pos.longitude,
        address: '',
        city: '',
      );

      if (stationsValue.isSuccess && stationsValue.data != null) {
        stationsValue = AsyncValue.success(
          _sortByDistance(stationsValue.data!),
        );
      }
    } catch (e) {
      debugPrint('GPS error: $e');
    }

    _isLocating = false;
    notifyListeners();
  }

  List<Station> _sortByDistance(List<Station> stations) {
    if (_userLocation == null) return stations;
    final sorted = List<Station>.from(stations);
    sorted.sort(
      (a, b) => a.location
          .distanceTo(_userLocation!)
          .compareTo(b.location.distanceTo(_userLocation!)),
    );
    return sorted;
  }

  double? distanceTo(Station s) =>
      _userLocation == null ? null : s.location.distanceTo(_userLocation!);

  String formatDistance(Station s) {
    final d = distanceTo(s);
    if (d == null) return '';
    return d < 1000 ? '${d.round()} m' : '${(d / 1000).toStringAsFixed(1)} km';
  }
}
