import 'package:flutter/material.dart';
import 'package:velotoulouse/model/booking/booking.dart';
import 'package:velotoulouse/ui/theme/theme.dart';

class ActiveBookingViewModel extends ChangeNotifier {
  Booking? _activeBooking;

  Booking? get activeBooking => _activeBooking;

  void setActiveBooking(Booking? booking) {
    _activeBooking = booking;
    notifyListeners();
  }

  void clearBooking() {
    _activeBooking = null;
    notifyListeners();
  }
}

class ActiveBookingPanel extends StatelessWidget {
  final ActiveBookingViewModel viewModel;
  final VoidCallback? onCancel;

  const ActiveBookingPanel({
    super.key,
    required this.viewModel,
    this.onCancel,
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
            padding: EdgeInsets.all(AppSpacings.m),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.green.shade300),
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
                        'Active Booking',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: const Text(
                          'Booked',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacings.m),
                  Text(
                    'Slot ${booking.bikeSlotId.split('_').last}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSpacings.s),
                  Text(
                    'Station ID: ${booking.stationId}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.secondary,
                    ),
                  ),
                  SizedBox(height: AppSpacings.m),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        viewModel.clearBooking();
                        onCancel?.call();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red.shade600,
                      ),
                      child: const Text('Cancel Booking'),
                    ),
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
