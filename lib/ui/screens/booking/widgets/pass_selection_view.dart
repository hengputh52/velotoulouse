import 'package:flutter/material.dart';
import 'package:velotoulouse/ui/screens/booking/widgets/bike_info_header.dart';
import 'package:velotoulouse/ui/screens/booking/widgets/pass_option_card.dart';
import 'package:velotoulouse/ui/theme/theme.dart';
import 'package:velotoulouse/ui/widgets/app_error_banner.dart';

/// View displayed when user needs to purchase a pass or ticket
class PassSelectionView extends StatelessWidget {
  final String stationName;
  final String slotId;
  final String? errorMessage;
  final List<PassOption> passOptions;

  const PassSelectionView({
    super.key,
    required this.stationName,
    required this.slotId,
    this.errorMessage,
    required this.passOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacings.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bike info header
              BikeInfoHeader(stationName: stationName, slotId: slotId),

              // Message banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSpacings.m),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(AppSpacings.radius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        SizedBox(width: AppSpacings.m),
                        Expanded(
                          child: Text(
                            'You need a pass or ticket to book a bike.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacings.m),
                    Text(
                      'Choose a pass type or buy a single ticket to proceed.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSpacings.xl),

              // Pass options header
              Text(
                'Available Options',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacings.m),

              // Pass options list
              ...passOptions.asMap().entries.map((entry) {
                final isLast = entry.key == passOptions.length - 1;
                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacings.m),
                  child: PassOptionCard(
                    title: entry.value.title,
                    price: entry.value.price,
                    duration: entry.value.duration,
                    onTap: entry.value.onTap,
                  ),
                );
              }).toList(),

              // Error message if any
              if (errorMessage != null)
                Column(
                  children: [
                    SizedBox(height: AppSpacings.m),
                    AppErrorBanner(message: errorMessage!),
                  ],
                ),

              SizedBox(height: 40), // Space for bottom
            ],
          ),
        ),
      ],
    );
  }
}

/// Model for pass option data
class PassOption {
  final String title;
  final String price;
  final String duration;
  final VoidCallback onTap;

  PassOption({
    required this.title,
    required this.price,
    required this.duration,
    required this.onTap,
  });
}
