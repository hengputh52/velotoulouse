import 'package:flutter/material.dart';
import 'package:velotoulouse/model/pass/pass.dart';
import 'package:velotoulouse/ui/screens/booking/widgets/bike_info_header.dart';
import 'package:velotoulouse/ui/screens/booking/widgets/pass_details_card.dart';
import 'package:velotoulouse/ui/states/view_state.dart';
import 'package:velotoulouse/ui/theme/theme.dart';
import 'package:velotoulouse/ui/widgets/app_error_banner.dart';
import 'package:velotoulouse/ui/widgets/app_primary_button.dart';

/// View displayed when user has an active pass
class PassConfirmationView extends StatelessWidget {
  final String stationName;
  final String slotId;
  final Pass activePass;
  final ViewState state;
  final String? errorMessage;
  final VoidCallback onConfirm;

  const PassConfirmationView({
    super.key,
    required this.stationName,
    required this.slotId,
    required this.activePass,
    required this.state,
    this.errorMessage,
    required this.onConfirm,
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

              // Active pass banner
              Text(
                'Your Active Pass',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: AppSpacings.m),

              // Pass details card
              PassDetailsCard(pass: activePass),

              SizedBox(height: AppSpacings.xl),

              // Error message if any
              if (errorMessage != null)
                Column(
                  children: [
                    AppErrorBanner(message: errorMessage!),
                    SizedBox(height: AppSpacings.m),
                  ],
                ),

              SizedBox(height: 120), // Space for sticky button
            ],
          ),
        ),

        // Sticky confirm button at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: EdgeInsets.all(AppSpacings.l),
            child: AppPrimaryButton(
              label: 'Confirm Booking',
              isLoading: state == ViewState.loading,
              onPressed: state != ViewState.loading ? onConfirm : null,
            ),
          ),
        ),
      ],
    );
  }
}
