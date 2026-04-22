import 'package:flutter/material.dart';
import 'package:velotoulouse/model/booking/booking.dart';
import 'package:velotoulouse/model/station/station.dart';
import 'package:velotoulouse/ui/screens/booking/booking_screen.dart';
import 'package:velotoulouse/ui/screens/station/station_slot_row.dart';
import 'package:velotoulouse/ui/screens/station/station_stat.dart';
import 'package:velotoulouse/ui/theme/theme.dart';

/// StationDetailScreen — full screen shown when user taps a map marker
///
/// Responsibilities:
///   • Display station info and slot list
///   • Track selected slot (local UI state only)
///   • Navigate to ConfirmBookingScreen when a slot is chosen
///
/// Architecture: StatefulWidget (no ViewModel needed — pure UI selection state)
class StationDetailScreen extends StatefulWidget {
  final Station station;
  final String distanceText;

  const StationDetailScreen({
    super.key,
    required this.station,
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Station Detail',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacings.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: AppSpacings.l),
            _buildStatsRow(),
            const SizedBox(height: AppSpacings.m),
            const Divider(),
            const SizedBox(height: AppSpacings.s),
            _buildSlotList(),
            const SizedBox(height: AppSpacings.l),
            _buildContinueButton(),
            const SizedBox(height: AppSpacings.l),
          ],
        ),
      ),
    );
  }

  // ── Header: name + distance ──────────────────────────────────
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                widget.station.name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Icon(Icons.favorite_border, color: Colors.grey.shade400),
          ],
        ),
        if (widget.distanceText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '${widget.distanceText} — from your current location',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
          ),
      ],
    );
  }

  // ── Stats: available bikes + docks ───────────────────────────
  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        StationStatBox(
          icon: Icons.pedal_bike,
          count: widget.station.availableCount,
          label: 'Available bike',
        ),
        Container(width: 1, height: 60, color: Colors.grey.shade200),
        StationStatBox(
          icon: Icons.local_parking,
          count: widget.station.totalDocks,
          label: 'Available dock',
          useParking: true,
        ),
      ],
    );
  }

  // ── Slot list ────────────────────────────────────────────────
  Widget _buildSlotList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Slot No.',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacings.s),
        ...widget.station.slots.map(
          (slot) => StationSlotRow(
            key: ValueKey(slot.id),
            slot: slot,
            isSelected: _selectedSlot?.id == slot.id,
            onSelected: (s) {
              if (!s.isAvailable) return;
              setState(() {
                _selectedSlot = _selectedSlot?.id == s.id ? null : s;
              });
            },
          ),
        ),
      ],
    );
  }

  // ── Continue button ──────────────────────────────────────────
  Widget _buildContinueButton() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _canContinue ? _onContinue : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: Colors.grey.shade300,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacings.radius),
              ),
            ),
            child: Text(
              'Continue',
              style: TextStyle(
                color: _canContinue ? Colors.white : Colors.grey.shade500,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        if (!_canContinue)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Center(
              child: Text(
                'Select an available slot to continue',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _onContinue() async {
    final Booking? createdBooking = await Navigator.push<Booking>(
      context,
      MaterialPageRoute(
        builder: (_) => BookingScreen(
          stationId: widget.station.id,
          bikeSlotId: _selectedSlot!.id,
        ),
      ),
    );

    if (createdBooking != null && mounted) {
      Navigator.pop(context, createdBooking);
    }
  }
}
