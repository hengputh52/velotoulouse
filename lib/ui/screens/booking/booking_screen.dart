import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velotoulouse/ui/screens/booking/booking_content.dart';
import 'package:velotoulouse/ui/screens/booking/view_model/booking_view_model.dart';

/// BookingScreen - Main screen for booking a bike
/// Handles 2 cases: 1) User has active pass, 2) User needs to buy pass/ticket
class BookingScreen extends StatelessWidget {
  final String stationId;
  final String bikeSlotId;

  const BookingScreen({
    super.key,
    required this.stationId,
    required this.bikeSlotId,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BookingViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Booking'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BookingContent(
        viewModel: vm,
        stationId: stationId,
        bikeSlotId: bikeSlotId,
      ),
    );
  }
}
