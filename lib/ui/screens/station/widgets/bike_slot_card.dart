import 'package:flutter/material.dart';
import 'package:velotoulouse/model/station/station.dart';
import 'package:velotoulouse/ui/screens/station/widgets/slot_status_badge.dart';
import 'package:velotoulouse/ui/theme/theme.dart';

class BikeSlotCard extends StatelessWidget {
  final BikeSlot slot;
  final bool isSelected;
  final VoidCallback onTap;

  const BikeSlotCard({
    super.key,
    required this.slot,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: slot.isAvailable ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (slot.isAvailable ? Colors.grey.shade300 : Colors.grey.shade200),
            width: isSelected ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(AppSpacings.radius),
          color: isSelected
              ? AppColors.primary.withOpacity(0.05)
              : (slot.isAvailable ? Colors.white : Colors.grey.shade100),
        ),
        child: Card(
          elevation: 0,
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.all(AppSpacings.l),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Slot ${slot.slotNumber}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: AppSpacings.s),
                            SlotStatusBadge(isAvailable: slot.isAvailable),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                if (isSelected)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
