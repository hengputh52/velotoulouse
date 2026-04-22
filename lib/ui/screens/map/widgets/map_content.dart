import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:velotoulouse/model/booking/booking.dart';
import 'package:velotoulouse/model/station/station.dart';
import 'package:velotoulouse/ui/screens/map/view_model/active_booking_view_model.dart';
import 'package:velotoulouse/ui/screens/map/widgets/active_booking_panel.dart';
import 'package:velotoulouse/ui/screens/station/view_model/station_detail_view_model.dart';
import 'package:velotoulouse/ui/screens/map/widgets/error_banner.dart';
import 'package:velotoulouse/ui/screens/map/widgets/marker_helper.dart';
import 'package:velotoulouse/ui/screens/map/widgets/my_location.dart';
import 'package:velotoulouse/ui/screens/map/widgets/search_bar.dart';
import 'package:velotoulouse/ui/screens/station/station_detail_screen.dart';

/// MapContent — renders map, station markers, and active booking banner.
class MapContent extends StatefulWidget {
  const MapContent({super.key});

  @override
  State<MapContent> createState() => _MapContentState();
}

class _MapContentState extends State<MapContent> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  List<Station>? _lastBuiltStations;

  // Toulouse city centre — matches data.json
  static const LatLng _toulouseCenter = LatLng(43.6047, 1.4442);

  @override
  Widget build(BuildContext context) {
    final stationVm = context.watch<StationViewModel>();
    final activeBookingVm = context.watch<ActiveBookingViewModel>();

    final List<Station>? displayList = stationVm.stationsValue.isSuccess
        ? (stationVm.filteredStations ?? stationVm.stationsValue.data)
        : null;

    // Rebuild markers only when the displayed station list changes
    if (displayList != null && displayList != _lastBuiltStations) {
      _lastBuiltStations = displayList;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _buildMarkers(displayList, stationVm),
      );
    }

    final double topPad = MediaQuery.of(context).padding.top;

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
            onMapCreated: (c) => _mapController = c,
          ),

          // ── 2. Search bar ─────────────────────────────────
          Positioned(
            top: topPad + 12,
            left: 16,
            right: 16,
            child: const SearchBarWidget(),
          ),

          // ── 3. Current Ride banner (below search bar) ─────
          if (activeBookingVm.activeBooking != null)
            Positioned(
              top: topPad + 76, // below search bar
              left: 16,
              right: 16,
              child: ActiveBookingPanel(viewModel: activeBookingVm),
            ),

          // ── 4. Loading spinner ────────────────────────────
          if (stationVm.stationsValue.isLoading)
            const Center(child: CircularProgressIndicator()),

          // ── 5. Error banner ───────────────────────────────
          if (stationVm.stationsValue.isError)
            Positioned(
              top: topPad + 80,
              left: 16,
              right: 16,
              child: ErrorBanner(onRetry: stationVm.fetchStations),
            ),

          // ── 6. Location FAB ───────────────────────────────
          Positioned(
            bottom: activeBookingVm.activeBooking != null ? 220 : 32,
            right: 16,
            child: LocationFabWidget(
              isLocating: stationVm.isLocating,
              onTap: () async {
                await stationVm.fetchUserLocation();
                if (stationVm.userLocation != null && _mapController != null) {
                  await _mapController!.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      LatLng(
                        stationVm.userLocation!.latitude,
                        stationVm.userLocation!.longitude,
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

    for (final station in stations) {
      // Always display numeric availability marker, including 0.
      final icon = await MarkerHelper.numbered(station.availableCount);

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

    if (mounted) setState(() => _markers = newMarkers);
  }

  Future<void> _navigateToDetail(Station station, StationViewModel vm) async {
    vm.selectStation(station);

    final Booking? createdBooking = await Navigator.push<Booking>(
      context,
      MaterialPageRoute(
        builder: (_) => StationDetailScreen(
          stationId: station.id,
          distanceText: vm.formatDistance(station),
        ),
      ),
    );

    if (createdBooking != null && mounted) {
      context.read<ActiveBookingViewModel>().setActiveBooking(
        createdBooking,
        stationName: station.name,
      );
    }
  }
}
