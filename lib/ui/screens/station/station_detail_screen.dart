import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velotoulouse/ui/screens/station/station_detail_content.dart';
import 'package:velotoulouse/ui/screens/station/station_detail_view_model.dart';

class StationDetailScreen extends StatelessWidget {
  final String stationId;
  final String distanceText;

  const StationDetailScreen({
    super.key,
    required this.stationId,
    required this.distanceText,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StationDetailViewModel(
        stationRepository: context.read(),
      )..loadStation(stationId),
      child: const StationDetailContent(),
    );
  }
}
