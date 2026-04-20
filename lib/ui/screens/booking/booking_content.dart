import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velotoulouse/model/payment/payment.dart';
import 'package:velotoulouse/ui/screens/auth/auth_view_model.dart';
import 'package:velotoulouse/ui/screens/booking/view_model/booking_view_model.dart';
import 'package:velotoulouse/ui/screens/payment/payment_screen.dart';
import 'package:velotoulouse/ui/screens/payment/payment_view_model.dart';
import 'package:velotoulouse/ui/states/view_state.dart';
import 'package:velotoulouse/ui/theme/theme.dart';
import 'package:velotoulouse/ui/widgets/app_error_banner.dart';
import 'package:velotoulouse/ui/widgets/app_primary_button.dart';
import 'package:provider/provider.dart';

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
    // Load data on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.loadStation(widget.stationId);
      widget.viewModel.loadActivePass(
        context.read<AuthViewModel>().currentUser?.id ?? '',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading state
    if (widget.viewModel.state == ViewState.loading &&
        widget.viewModel.currentStation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show error state
    if (widget.viewModel.errorMessage != null &&
        widget.viewModel.currentStation == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppErrorBanner(message: widget.viewModel.errorMessage!),
            const SizedBox(height: 20),
            AppPrimaryButton(
              label: 'Retry',
              onPressed: () {
                widget.viewModel.loadStation(widget.stationId);
                widget.viewModel.loadActivePass(
                  context.read<AuthViewModel>().currentUser?.id ?? '',
                );
              },
            ),
          ],
        ),
      );
    }

    // CASE 1: User has active pass
    if (widget.viewModel.hasActivePass) {
      return _buildWithPassCase(context);
    }

    // CASE 2: User has NO active pass
    return _buildWithoutPassCase(context);
  }

  // ============================================================================
  // CASE 1: USER HAS ACTIVE PASS - Show pass details + confirm button
  // ============================================================================
  Widget _buildWithPassCase(BuildContext context) {
    final station = widget.viewModel.currentStation;
    final pass = widget.viewModel.activePass;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacings.l),
          child: Column(
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
                station?.name.toUpperCase() ?? 'Loading...',
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
                    'Slot ${widget.bikeSlotId}',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.neutralLight,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacings.l),
              const Divider(),
              SizedBox(height: AppSpacings.l),

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
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSpacings.m),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green.shade300),
                  borderRadius: BorderRadius.circular(AppSpacings.radius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          pass?.type.name.toUpperCase() ?? 'PASS',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.green.shade700,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade600,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Active',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Expires',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.neutralLight,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              pass?.expiresAt.toString().split(' ')[0] ?? 'N/A',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Days Left',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.neutralLight,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${pass?.daysLeft ?? 0} days',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSpacings.xl),

              // Error message if any
              if (widget.viewModel.errorMessage != null)
                Column(
                  children: [
                    AppErrorBanner(message: widget.viewModel.errorMessage!),
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
              isLoading: widget.viewModel.state == ViewState.loading,
              onPressed: widget.viewModel.state != ViewState.loading
                  ? () => _confirmBookingWithPass(context)
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // CASE 2: USER HAS NO PASS - Show message + button to payment
  // ============================================================================
  Widget _buildWithoutPassCase(BuildContext context) {
    final station = widget.viewModel.currentStation;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacings.l),
          child: Column(
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
                station?.name.toUpperCase() ?? 'Loading...',
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
                    'Slot ${widget.bikeSlotId}',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.neutralLight,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacings.l),
              const Divider(),
              SizedBox(height: AppSpacings.l),

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

              // Pass options grid
              Text(
                'Available Options',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacings.m),

              final currencyFormatter = NumberFormat.simpleCurrency(name: 'EUR');

              // Single ticket option
              _buildOptionCard(
                title: 'Single Ticket',
                price: currencyFormatter.format(1.50),
                duration: '1 ride',
                onTap: () => _goToPayment(context, 'singleTicket', 1.50),
              ),
              SizedBox(height: AppSpacings.m),

              // Day pass option
              _buildOptionCard(
                title: 'Day Pass',
                price: currencyFormatter.format(5.00),
                duration: '24 hours',
                onTap: () => _goToPayment(context, 'dayPass', 5.00),
              ),
              SizedBox(height: AppSpacings.m),

              // Monthly pass option
              _buildOptionCard(
                title: 'Monthly Pass',
                price: currencyFormatter.format(15.00),
                duration: '30 days',
                onTap: () => _goToPayment(context, 'monthlyPass', 15.00),
              ),
              SizedBox(height: AppSpacings.m),

              // Annual pass option
              _buildOptionCard(
                title: 'Annual Pass',
                price: '€99.00',
                duration: '365 days',
                onTap: () => _goToPayment(context, 'annualPass', 99.00),
              ),

              // Error message if any
              if (widget.viewModel.errorMessage != null)
                Column(
                  children: [
                    SizedBox(height: AppSpacings.m),
                    AppErrorBanner(message: widget.viewModel.errorMessage!),
                  ],
                ),

              SizedBox(height: 40), // Space for bottom
            ],
          ),
        ),
      ],
    );
  }

  // Helper widget for option cards
  Widget _buildOptionCard({
    required String title,
    required String price,
    required String duration,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacings.m),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(AppSpacings.radius),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  duration,
                  style: TextStyle(fontSize: 12, color: AppColors.neutralLight),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: AppColors.neutralLight.withOpacity(0.5),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Navigate to payment screen
  void _goToPayment(BuildContext context, String passType, double amount) {
    try {
      // Map passType string to PaymentPurpose enum
      final purposeMap = {
        'singleTicket': PaymentPurpose.singleTicket,
        'dayPass': PaymentPurpose.dayPass,
        'monthlyPass': PaymentPurpose.monthlyPass,
        'annualPass': PaymentPurpose.annualPass,
      };

      final purpose = purposeMap[passType] ?? PaymentPurpose.singleTicket;

      // Get PaymentViewModel and initialize it
      final paymentViewModel = context.read<PaymentViewModel>();
      paymentViewModel.init(
        purpose: purpose,
        amount: amount,
        slotId: widget.bikeSlotId,
        stationId: widget.stationId,
      );

      // Navigate to PaymentScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(viewModel: paymentViewModel),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error navigating to payment: $e')),
      );
    }
  }

  // Confirm booking with pass
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
          if (widget.viewModel.state == ViewState.success) {
            _showSuccessDialog(context);
          }
        });
  }

  // Show success confirmation dialog
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
                    Navigator.of(context)
                      ..pop() // dialog
                      ..pop() // booking screen
                      ..pop(); // station detail
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
