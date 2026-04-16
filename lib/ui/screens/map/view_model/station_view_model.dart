import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:velotoulouse/data/repositories/station/station_repository.dart';
import 'package:velotoulouse/model/location/location.dart';
import 'package:velotoulouse/model/station/station.dart';
import 'package:velotoulouse/ui/utils/async_value.dart';

/// US2-05: StationViewModel — loading / success / error states
/// LOC-05: Sort stations by distance to user GPS
class StationViewModel extends ChangeNotifier {
  final StationRepository stationRepository;

  // US2-05: the 3 states
  AsyncValue<List<Station>> stationsValue = AsyncValue.loading();

  // selected station → used by detail sheet
  Station? selectedStation;

  // user GPS location
  Location? _userLocation;
  Location? get userLocation => _userLocation;

  bool _isLocating = false;
  bool get isLocating => _isLocating;

  StationViewModel({required this.stationRepository}) {
    _init();
  }

  void _init() async {
    await fetchStations();
    await fetchUserLocation();
  }

  // Add this to StationViewModel class:

  List<Station>? _filteredStations;
  String _searchQuery = '';

  List<Station>? get filteredStations => _filteredStations;
  String get searchQuery => _searchQuery;

  /// Filter stations by search query (name, address)
  void searchStations(String query) {
    _searchQuery = query;

    if (!stationsValue.isSuccess || stationsValue.data == null) {
      _filteredStations = null;
      notifyListeners();
      return;
    }

    if (query.isEmpty) {
      _filteredStations = null; // Show all when empty
    } else {
      _filteredStations = stationsValue.data!
          .where(
            (station) =>
                station.name.toUpperCase().contains(query.toUpperCase()) ||
                station.address!.toUpperCase().contains(query.toUpperCase()),
          )
          .toList();
      // Keep sorted by distance
      _filteredStations = _sortByDistance(_filteredStations!);
    }

    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredStations = null;
    notifyListeners();
  }

  // ── Fetch stations via HTTP ────────────────────────────────
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

  // ── Select station for detail sheet ───────────────────────
  void selectStation(Station station) {
    selectedStation = station;
    notifyListeners();
  }

  void clearSelectedStation() {
    selectedStation = null;
    notifyListeners();
  }

  // ── Get GPS + sort ─────────────────────────────────────────
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

  // ── LOC-05: Sort closest first ─────────────────────────────
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

  // ── Distance helpers ───────────────────────────────────────
  double? distanceTo(Station s) =>
      _userLocation == null ? null : s.location.distanceTo(_userLocation!);

  String formatDistance(Station s) {
    final d = distanceTo(s);
    if (d == null) return '';
    return d < 1000 ? '${d.round()} m' : '${(d / 1000).toStringAsFixed(1)} km';
  }
}
