import 'package:flutter/material.dart';
import 'package:velotoulouse/ui/theme/theme.dart';
import 'package:velotoulouse/ui/widgets/app_primary_button.dart';

/// Dialog displayed after successful booking confirmation
class BookingSuccessDialog extends StatelessWidget {
  final String stationName;
  final VoidCallback onBackToMap;

  const BookingSuccessDialog({
    super.key,
    required this.stationName,
    required this.onBackToMap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacings.radiusLarge),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacings.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 48,
              ),
            ),
            SizedBox(height: AppSpacings.m),
            Text(
              'Booking Confirmed!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacings.s),
            Text(
              'Bike at $stationName has been reserved.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.neutralLight),
            ),
            SizedBox(height: AppSpacings.l),
            SizedBox(
              width: double.infinity,
              child: AppPrimaryButton(
                label: 'Back to Map',
                onPressed: onBackToMap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
