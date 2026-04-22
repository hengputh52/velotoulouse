import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velotoulouse/data/repositories/station/station_repository.dart';
import 'package:velotoulouse/model/station/station.dart';
import 'package:velotoulouse/ui/screens/station/station_detail_content.dart';
import 'package:velotoulouse/ui/screens/station/station_detail_view_model.dart';

class StationDetailScreen extends StatefulWidget {
  final String stationId;
  final String distanceText;

  const StationDetailScreen({
    super.key,
    required this.stationId,
    required this.distanceText,
  });

  @override
  State<StationDetailScreen> createState() => _StationDetailScreenState();
}

class _StationDetailScreenState extends State<StationDetailScreen> {
  BikeSlot? _selectedSlot;

  bool get _canContinue => _selectedSlot != null && _selectedSlot!.isAvailable;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ProxyProvider<StationRepository, StationDetailViewModel>(
          update: (_, stationRepo, __) => StationDetailViewModel(
            stationRepo,
            context.read(),
            stationRepository: stationRepo,
            bookingRepository: context.read(),
          ),
        ),
      ],
      child: const StationDetailContent(),
    );
  }
}
