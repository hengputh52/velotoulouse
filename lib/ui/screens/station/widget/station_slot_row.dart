import 'package:flutter/material.dart';
import 'package:velotoulouse/model/station/station.dart';
import 'package:velotoulouse/ui/theme/theme.dart';

/// StationSlotRow — one row in the slot list
/// Available slots: swipe left OR tap to select; shows blue highlight when selected
/// Unavailable slots: shows "In maintenance" + X icon, not interactive
class StationSlotRow extends StatelessWidget {
  final BikeSlot slot;
  final bool isSelected;
  final ValueChanged<BikeSlot> onSelected;

  const StationSlotRow({
    super.key,
    required this.slot,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (!slot.isAvailable) {
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

    // Available: wrap in Dismissible for swipe-left gesture
    return Dismissible(
      key: ValueKey('swipe_${slot.id}'),
      direction: DismissDirection.endToStart,
      // confirmDismiss: select the slot but don't remove the row
      confirmDismiss: (_) async {
        onSelected(slot);
        return false;
      },
      background: _SwipeBackground(),
      child: GestureDetector(
        onTap: () => onSelected(slot),
        child: _SlotContainer(
          slot: slot,
          isSelected: isSelected,
          trailing: isSelected
              ? _SelectedCheck()
              : _ReleaseButton(onTap: () => onSelected(slot)),
        ),
      ),
    );
  }
}

// ── Private helpers (internal to this file) ───────────────────

class _SwipeBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _SelectedCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        color: Color(0xFF1275E2),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.check, size: 16, color: Colors.white),
    );
  }
}

class _ReleaseButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ReleaseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: const Text(
        'Release the bike',
        style: TextStyle(color: Colors.white, fontSize: 11),
      ),
    );
  }
}

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
          // Slot number
          SizedBox(
            width: 20,
            child: Text(
              '${slot.slotNumber}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),

          // Bike icon
          const Icon(Icons.pedal_bike, size: 22, color: Colors.black54),
          const SizedBox(width: 10),

          // Status (battery bar or maintenance text)
          Expanded(
            child: slot.isAvailable
                ? _BatteryStatus()
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

class _BatteryStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
