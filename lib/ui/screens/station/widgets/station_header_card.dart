import 'package:flutter/material.dart';
import 'package:velotoulouse/model/station/station.dart';
import 'package:velotoulouse/ui/theme/theme.dart';

class StationHeaderCard extends StatelessWidget {
  final Station station;

  const StationHeaderCard({
    super.key,
    required this.station,
  });

  @override
  Widget build(BuildContext context) {
    final availableCount = station.availableBikes;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacings.radius),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacings.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              station.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacings.s),
            if (station.address != null)
              Text(
                station.address!,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.secondary,
                ),
              ),
            SizedBox(height: AppSpacings.m),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$availableCount bikes available',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: availableCount > 0
                            ? Colors.green.shade600
                            : Colors.red.shade600,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                  size: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
