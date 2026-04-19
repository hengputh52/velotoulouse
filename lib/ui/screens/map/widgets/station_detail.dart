import 'package:flutter/material.dart';
import 'package:velotoulouse/model/station/station.dart';
import 'package:velotoulouse/model/pass/pass.dart';
import 'package:velotoulouse/ui/screens/booking/booking_screen.dart';
import 'package:velotoulouse/ui/theme/theme.dart';

/// StationDetailScreen — full screen (StatefulWidget)
/// Tracks: selected slot (via swipe or tap) + selected pass type
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
  PassType? _selectedPass;
  BikeSlot? _selectedSlot;

  bool get _canContinue =>
      _selectedSlot != null &&
      _selectedSlot!.isAvailable &&
      _selectedPass != null;

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
            // ── Name + heart ─────────────────────────────────
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

            const SizedBox(height: AppSpacings.l),

            // ── Stats ────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatBox(
                  icon: Icons.pedal_bike,
                  count: widget.station.availableCount,
                  label: 'Available bike',
                ),
                Container(width: 1, height: 60, color: Colors.grey.shade200),
                _StatBox(
                  count: widget.station.totalDocks,
                  label: 'Available dock',
                  useParking: true,
                ),
              ],
            ),

            const SizedBox(height: AppSpacings.m),
            const Divider(),
            const SizedBox(height: AppSpacings.s),

            // ── Slot list ────────────────────────────────────
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
              (slot) => _SwipeableSlotRow(
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

            const SizedBox(height: AppSpacings.xl),

            // ── Choose Your Pass ─────────────────────────────
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(text: 'Choose '),
                  TextSpan(
                    text: 'Your Pass',
                    style: TextStyle(color: Color(0xFF1275E2)),
                  ),
                  TextSpan(text: ' ?'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacings.m),

            // Pass options for all PassType values
            ...PassType.values.map(
              (passType) => _PassOptionRow(
                passType: passType,
                isSelected: _selectedPass == passType,
                onChanged: (p) => setState(() => _selectedPass = p),
              ),
            ),

            const SizedBox(height: AppSpacings.l),

            // ── Continue button ──────────────────────────────
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
                    'Select an available slot and a pass to continue',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                  ),
                ),
              ),

            const SizedBox(height: AppSpacings.l),
          ],
        ),
      ),
    );
  }

  void _onContinue() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmBookingScreen(
          station: widget.station,
          slot: _selectedSlot!,
          passType: _selectedPass!,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Swipeable Slot Row
// ─────────────────────────────────────────────────────────────

class _SwipeableSlotRow extends StatelessWidget {
  final BikeSlot slot;
  final bool isSelected;
  final ValueChanged<BikeSlot> onSelected;

  const _SwipeableSlotRow({
    super.key,
    required this.slot,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (!slot.isAvailable) {
      // Non-available: not swipeable, shows maintenance + X icon
      return _SlotContainer(
        slot: slot,
        isSelected: false,
        trailing: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.close, size: 16, color: Colors.green),
        ),
      );
    }

    // Available: swipe left reveals "Release" or tap to select
    return Dismissible(
      key: ValueKey('swipe_${slot.id}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onSelected(slot); // select on swipe
        return false; // don't remove from list
      },
      // Revealed background when swiping left
      background: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.pedal_bike, color: Colors.white, size: 18),
            SizedBox(width: 6),
            Text(
              'Release',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: () => onSelected(slot),
        child: _SlotContainer(
          slot: slot,
          isSelected: isSelected,
          trailing: isSelected
              ? Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1275E2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 16, color: Colors.white),
                )
              : ElevatedButton(
                  onPressed: () => onSelected(slot),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Release the bike',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Slot Container (shared layout for both available/unavailable)
// ─────────────────────────────────────────────────────────────

class _SlotContainer extends StatelessWidget {
  final BikeSlot slot;
  final bool isSelected;
  final Widget trailing;

  const _SlotContainer({
    required this.slot,
    required this.isSelected,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF1275E2).withOpacity(0.06)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF1275E2).withOpacity(0.5)
              : Colors.grey.shade200,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: Text(
              '${slot.slotNumber}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.pedal_bike, size: 22, color: Colors.black54),
          const SizedBox(width: 10),
          Expanded(
            child: slot.isAvailable
                ? Row(
                    children: [
                      Container(
                        width: 50,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 1.0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Fully charged',
                        style: TextStyle(fontSize: 12, color: Colors.green),
                      ),
                    ],
                  )
                : Text(
                    'In maintenance',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
          ),
          trailing,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Stat Box
// ─────────────────────────────────────────────────────────────

class _StatBox extends StatelessWidget {
  final IconData? icon;
  final int count;
  final String label;
  final bool useParking;

  const _StatBox({
    this.icon,
    required this.count,
    required this.label,
    this.useParking = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        useParking
            ? Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child: Text(
                    'P',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              )
            : Icon(icon, size: 32, color: Colors.black87),
        const SizedBox(height: 4),
        Text(
          '$count',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Pass Option Row (radio group member)
// ─────────────────────────────────────────────────────────────

class _PassOptionRow extends StatelessWidget {
  final PassType passType;
  final bool isSelected;
  final ValueChanged<PassType> onChanged;

  const _PassOptionRow({
    required this.passType,
    required this.isSelected,
    required this.onChanged,
  });

  String _getPassLabel(PassType type) {
    return switch (type) {
      PassType.single => 'Quick Ride',
      PassType.day => 'Day Pass',
      PassType.monthly => 'Monthly Plan',
      PassType.annual => 'Annual Plan',
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(passType),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1275E2).withOpacity(0.06)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1275E2).withOpacity(0.4)
                : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.confirmation_number_outlined,
              size: 20,
              color: isSelected ? AppColors.primary : Colors.black54,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getPassLabel(passType),
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? AppColors.primary : Colors.black87,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  Text(
                    '${passType.duration} • €${passType.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            Radio<PassType>(
              value: passType,
              groupValue: isSelected ? passType : null,
              onChanged: (v) => onChanged(v!),
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
