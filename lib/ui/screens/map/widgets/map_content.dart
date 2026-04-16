import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:velotoulouse/model/station/station.dart';
import 'package:velotoulouse/ui/screens/map/view_model/station_view_model.dart';
import 'package:velotoulouse/ui/screens/map/widgets/error_banner.dart';
import 'package:velotoulouse/ui/screens/map/widgets/my_location.dart';
import 'package:velotoulouse/ui/screens/map/widgets/marker_helper.dart';
import 'package:velotoulouse/ui/screens/map/widgets/search_bar.dart';
import 'package:velotoulouse/ui/screens/map/widgets/station_detail.dart';

/// MapContent — StatefulWidget
/// Responsibility: show GoogleMap, markers, overlays
class MapContent extends StatefulWidget {
  const MapContent({super.key});

  @override
  State<MapContent> createState() => _MapContentState();
}

class _MapContentState extends State<MapContent> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  // Track the last stations list used to build markers so we only rebuild when
  // the data actually changes (avoids rebuilding on every unrelated notify).
  List<Station>? _lastBuiltStations;

  // Toulouse city centre — matches data.json coordinates
  static const LatLng _toulouseCenter = LatLng(43.6047, 1.4442);

  @override
  Widget build(BuildContext context) {
    final StationViewModel vm = context.watch<StationViewModel>();

    // Decide which list to show: filtered (search) or full list
    final List<Station>? displayList = vm.stationsValue.isSuccess
        ? (vm.filteredStations ?? vm.stationsValue.data)
        : null;

    // Rebuild markers whenever the display list changes
    if (displayList != null && displayList != _lastBuiltStations) {
      _lastBuiltStations = displayList;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _buildMarkers(displayList, vm),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // ── 1. Google Map ─────────────────────────────────
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _toulouseCenter,
              zoom: 14.5,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
          ),

          // ── 2. Search bar ─────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: const SearchBarWidget(),
          ),

          // ── 3. Loading spinner ────────────────────────────
          if (vm.stationsValue.isLoading)
            const Center(child: CircularProgressIndicator()),

          // ── 4. Error banner ───────────────────────────────
          if (vm.stationsValue.isError)
            Positioned(
              top: MediaQuery.of(context).padding.top + 80,
              left: 16,
              right: 16,
              child: ErrorBanner(onRetry: vm.fetchStations),
            ),

          // ── 5. Location FAB ───────────────────────────────
          Positioned(
            bottom: 32,
            right: 16,
            child: LocationFabWidget(
              isLocating: vm.isLocating,
              onTap: () async {
                await vm.fetchUserLocation();
                if (vm.userLocation != null && _mapController != null) {
                  await _mapController!.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      LatLng(
                        vm.userLocation!.latitude,
                        vm.userLocation!.longitude,
                      ),
                      15,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _buildMarkers(
    List<Station> stations,
    StationViewModel vm,
  ) async {
    final Set<Marker> newMarkers = {};

    for (final Station station in stations) {
      final BitmapDescriptor icon = station.hasBikesAvailable
          ? await MarkerHelper.numbered(station.availableCount)
          : await MarkerHelper.empty();

      newMarkers.add(
        Marker(
          markerId: MarkerId(station.id),
          position: LatLng(
            station.location.latitude,
            station.location.longitude,
          ),
          icon: icon,
          onTap: () => _navigateToDetail(station, vm),
        ),
      );
    }

    if (mounted) {
      setState(() => _markers = newMarkers);
    }
  }

  // ── Navigate to full Station Detail screen on marker tap ──
  void _navigateToDetail(Station station, StationViewModel vm) {
    vm.selectStation(station);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StationDetailScreen(
          station: station,
          distanceText: vm.formatDistance(station),
        ),
      ),
    );
  }
}
