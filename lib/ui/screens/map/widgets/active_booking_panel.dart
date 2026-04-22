import 'package:flutter/material.dart';
import 'package:velotoulouse/ui/screens/map/view_model/active_booking_view_model.dart';
import 'package:velotoulouse/ui/theme/theme.dart';

class ActiveBookingPanel extends StatelessWidget {
  final ActiveBookingViewModel viewModel;
  final VoidCallback? onCancel;

  const ActiveBookingPanel({
    super.key,
    required this.viewModel,
    this.onCancel,
    required String stationId,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.activeBooking == null) {
          return const SizedBox.shrink();
        }

        final booking = viewModel.activeBooking!;

        return AnimatedSlide(
          duration: const Duration(milliseconds: 300),
          offset: viewModel.activeBooking != null
              ? Offset.zero
              : const Offset(0, 2),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacings.m),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(AppSpacings.radius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.all(AppSpacings.m),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CURRENT RIDE',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacings.m),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          (viewModel.stationName ?? booking.stationId)
                              .toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacings.s),
                  Row(
                    children: [
                      const Icon(Icons.pedal_bike_outlined, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'Slot ${booking.bikeSlotId.split('_').last}',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.secondary,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          viewModel.clearBooking();
                          onCancel?.call();
                        },
                        child: Text(
                          'Clear',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
