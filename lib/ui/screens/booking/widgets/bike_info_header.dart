import 'package:flutter/material.dart';
import 'package:velotoulouse/ui/theme/theme.dart';

/// Header widget showing bike image, station name, and slot information
class BikeInfoHeader extends StatelessWidget {
  final String stationName;
  final String slotId;

  const BikeInfoHeader({
    super.key,
    required this.stationName,
    required this.slotId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bike image placeholder
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacings.radius),
          child: Container(
            width: double.infinity,
            height: 200,
            color: const Color(0xFFD6F0EF),
            child: const Icon(
              Icons.pedal_bike,
              size: 120,
              color: Color(0xFF3CBAB3),
            ),
          ),
        ),
        SizedBox(height: AppSpacings.l),

        // Station name
        Text(
          stationName.toUpperCase(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSpacings.s),

        // Slot info
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 14,
              color: AppColors.neutralLight,
            ),
            const SizedBox(width: 4),
            Text(
              'Slot $slotId',
              style: TextStyle(fontSize: 13, color: AppColors.neutralLight),
            ),
          ],
        ),
        SizedBox(height: AppSpacings.l),
        const Divider(),
        SizedBox(height: AppSpacings.l),
      ],
    );
  }
}
