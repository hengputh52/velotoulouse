import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velotoulouse/model/booking/booking.dart';
import 'package:velotoulouse/model/payment/payment.dart';
import 'package:velotoulouse/ui/screens/auth/auth_view_model.dart';
import 'package:velotoulouse/ui/screens/booking/view_model/booking_view_model.dart';
import 'package:velotoulouse/ui/screens/booking/widgets/pass_confirmation_view.dart';
import 'package:velotoulouse/ui/screens/booking/widgets/pass_selection_view.dart';
import 'package:velotoulouse/ui/screens/payment/payment_screen.dart';
import 'package:velotoulouse/ui/screens/payment/view_model/payment_view_model.dart';
import 'package:velotoulouse/ui/states/view_state.dart';
import 'package:velotoulouse/ui/theme/theme.dart';
import 'package:velotoulouse/ui/widgets/app_error_banner.dart';
import 'package:velotoulouse/ui/widgets/app_primary_button.dart';

class BookingContent extends StatefulWidget {
  final BookingViewModel viewModel;
  final String stationId;
  final String bikeSlotId;

  const BookingContent({
    super.key,
    required this.viewModel,
    required this.stationId,
    required this.bikeSlotId,
  });

  @override
  State<BookingContent> createState() => _BookingContentState();
}

class _BookingContentState extends State<BookingContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthViewModel>().currentUser?.id ?? '';
      widget.viewModel.loadStation(widget.stationId);
      if (userId.isNotEmpty) {
        widget.viewModel.loadActivePass(userId);
        widget.viewModel.loadCurrentRideStatus(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;

    // Loading: station or ride-check not ready yet
    if (vm.state == ViewState.loading && vm.currentStation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Error before any content loaded
    if (vm.errorMessage != null && vm.currentStation == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppErrorBanner(message: vm.errorMessage!),
            const SizedBox(height: 20),
            AppPrimaryButton(
              label: 'Retry',
              onPressed: () {
                final userId =
                    context.read<AuthViewModel>().currentUser?.id ?? '';
                vm.loadStation(widget.stationId);
                if (userId.isNotEmpty) {
                  vm.loadActivePass(userId);
                  vm.loadCurrentRideStatus(userId);
                }
              },
            ),
          ],
        ),
      );
    }

    if (vm.currentRide) {
      return _buildAlreadyRidingBlock(context);
    }

    final stationName = vm.currentStation?.name ?? 'Station';

    if (vm.hasActivePass) {
      return PassConfirmationView(
        stationName: stationName,
        slotId: widget.bikeSlotId,
        activePass: vm.activePass!,
        state: vm.state,
        errorMessage: vm.errorMessage,
        onConfirm: () => _confirmBookingWithPass(context),
      );
    }

    return _buildWithoutPassCase(context);
  }

  Widget _buildAlreadyRidingBlock(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacings.l),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_bike, size: 72, color: AppColors.primary),
            SizedBox(height: AppSpacings.l),
            Text(
              'You have an active ride',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacings.s),
            Text(
              'Return your current bike before booking a new one.',
              style: TextStyle(fontSize: 14, color: AppColors.neutralLight),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacings.l),
            AppPrimaryButton(
              label: 'Back to Map',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWithoutPassCase(BuildContext context) {
    final stationName = widget.viewModel.currentStation?.name ?? 'Station';

    return PassSelectionView(
      stationName: stationName,
      slotId: widget.bikeSlotId,
      errorMessage: widget.viewModel.errorMessage,
      passOptions: _buildPassOptions(context),
    );
  }

  List<PassOption> _buildPassOptions(BuildContext context) {
    return [
      PassOption(
        title: 'Single Ticket',
        price: '€1.50',
        duration: '1 ride',
        onTap: () => _goToPayment(context, PaymentPurpose.singleTicket, 1.50),
      ),
      PassOption(
        title: 'Day Pass',
        price: '€5.00',
        duration: '24 hours',
        onTap: () => _goToPayment(context, PaymentPurpose.dayPass, 5.00),
      ),
      PassOption(
        title: 'Monthly Pass',
        price: '€15.00',
        duration: '30 days',
        onTap: () => _goToPayment(context, PaymentPurpose.monthlyPass, 15.00),
      ),
      PassOption(
        title: 'Annual Pass',
        price: '€99.00',
        duration: '365 days',
        onTap: () => _goToPayment(context, PaymentPurpose.annualPass, 99.00),
      ),
    ];
  }

  Future<void> _goToPayment(
    BuildContext context,
    PaymentPurpose purpose,
    double amount,
  ) async {
    final paymentViewModel = context.read<PaymentViewModel>();
    paymentViewModel.init(
      purpose: purpose,
      amount: amount,
      slotId: widget.bikeSlotId,
      stationId: widget.stationId,
    );

    final Booking? createdBooking = await Navigator.push<Booking>(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(viewModel: paymentViewModel),
      ),
    );

    if (!context.mounted) return;

    if (createdBooking != null) {
      Navigator.of(context).pop(createdBooking);
    } else {
      // Pass may have been purchased — refresh pass status
      final userId = context.read<AuthViewModel>().currentUser?.id ?? '';
      if (userId.isNotEmpty) {
        await widget.viewModel.loadActivePass(userId);
        await widget.viewModel.loadCurrentRideStatus(userId);
      }
    }
  }

  void _confirmBookingWithPass(BuildContext context) {
    final userId = context.read<AuthViewModel>().currentUser?.id ?? '';
    final pass = widget.viewModel.activePass;

    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: User not authenticated')),
      );
      return;
    }

    if (pass == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: No active pass found')),
      );
      return;
    }

    widget.viewModel
        .confirmBooking(
          userId: userId,
          bikeSlotId: widget.bikeSlotId,
          stationId: widget.stationId,
          passId: pass.id,
          paymentId: null,
        )
        .then((_) {
          if (!context.mounted) return;
          if (widget.viewModel.state == ViewState.success) {
            _showSuccessDialog(context);
          }
        });
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
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
                'Bike at ${widget.viewModel.currentStation?.name ?? 'Station'} has been reserved.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.neutralLight),
              ),
              SizedBox(height: AppSpacings.l),
              SizedBox(
                width: double.infinity,
                child: AppPrimaryButton(
                  label: 'Back to Map',
                  onPressed: () {
                    final createdBooking = widget.viewModel.currentBooking;
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(createdBooking);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
