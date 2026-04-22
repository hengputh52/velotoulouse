import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velotoulouse/data/repositories/station/station_repository.dart';
import 'package:velotoulouse/ui/screens/map/view_model/active_booking_view_model.dart';
import 'package:velotoulouse/ui/screens/station/view_model/station_detail_view_model.dart';
import 'package:velotoulouse/ui/screens/map/widgets/map_content.dart';

/// MapScreen — StatefulWidget
/// Responsibility: create StationViewModel and inject it via Provider
/// Then hand off to MapContent for the actual UI
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StationViewModel>(
          create: (context) => StationViewModel(
            stationRepository: context.read<StationRepository>(),
          ),
        ),
        ChangeNotifierProvider(create: (context) => ActiveBookingViewModel()),
      ],
      child: const MapContent(),
    );
  }
}
