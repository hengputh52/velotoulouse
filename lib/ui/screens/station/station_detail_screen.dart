import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velotoulouse/data/repositories/station/station_repository.dart';
import 'package:velotoulouse/ui/screens/station/station_detail_content.dart';
import 'package:velotoulouse/ui/screens/station/station_detail_view_model.dart';

class StationDetailScreen extends StatefulWidget {
  final String stationId;

  const StationDetailScreen({
    super.key,
    required this.stationId,
  });

  @override
  State<StationDetailScreen> createState() => _StationDetailScreenState();
}

class _StationDetailScreenState extends State<StationDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StationDetailViewModel>().loadStation(widget.stationId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ProxyProvider<StationRepository, StationDetailViewModel>(
          update: (_, stationRepo, __) => StationDetailViewModel(stationRepo),
        ),
      ],
      child: const StationDetailContent(),
    );
  }
}
