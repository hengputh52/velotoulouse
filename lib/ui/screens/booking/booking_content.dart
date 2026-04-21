import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:velotoulouse/model/payment/payment.dart';
import 'package:velotoulouse/ui/screens/auth/auth_view_model.dart';
import 'package:velotoulouse/ui/screens/booking/view_model/booking_view_model.dart';
import 'package:velotoulouse/ui/screens/booking/widgets/booking_success_dialog.dart';
import 'package:velotoulouse/ui/screens/booking/widgets/pass_confirmation_view.dart';
import 'package:velotoulouse/ui/screens/booking/widgets/pass_selection_view.dart';
import 'package:velotoulouse/ui/screens/payment/payment_screen.dart';
import 'package:velotoulouse/ui/screens/payment/payment_view_model.dart';
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
              onPressed: () => _retryLoading(context),
            ),
          ],
        ),
      );
    }

    final stationName = widget.viewModel.currentStation?.name ?? 'Station';

    // CASE 1: User has active pass
    if (widget.viewModel.hasActivePass) {
      return PassConfirmationView(
        stationName: stationName,
        slotId: widget.bikeSlotId,
        activePass: widget.viewModel.activePass!,
        state: widget.viewModel.state,
        errorMessage: widget.viewModel.errorMessage,
        onConfirm: () => _confirmBookingWithPass(context),
      );
    }

    // CASE 2: User has NO active pass
    return PassSelectionView(
      stationName: stationName,
      slotId: widget.bikeSlotId,
      errorMessage: widget.viewModel.errorMessage,
      passOptions: _buildPassOptions(context),
    );
  }

  // Retry loading station and pass data
  void _retryLoading(BuildContext context) {
    widget.viewModel.loadStation(widget.stationId);
    widget.viewModel.loadActivePass(
      context.read<AuthViewModel>().currentUser?.id ?? '',
    );
  }

  // Build pass options for users without active pass
  List<PassOption> _buildPassOptions(BuildContext context) {
    final currencyFormatter = NumberFormat.simpleCurrency(name: 'EUR');

    return [
      PassOption(
        title: 'Single Ticket',
        price: currencyFormatter.format(1.50),
        duration: '1 ride',
        onTap: () => _goToPayment(context, 'singleTicket', 1.50),
      ),
      PassOption(
        title: 'Day Pass',
        price: currencyFormatter.format(5.00),
        duration: '24 hours',
        onTap: () => _goToPayment(context, 'dayPass', 5.00),
      ),
      PassOption(
        title: 'Monthly Pass',
        price: currencyFormatter.format(15.00),
        duration: '30 days',
        onTap: () => _goToPayment(context, 'monthlyPass', 15.00),
      ),
      PassOption(
        title: 'Annual Pass',
        price: '€99.00',
        duration: '365 days',
        onTap: () => _goToPayment(context, 'annualPass', 99.00),
      ),
    ];
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
      builder: (_) => BookingSuccessDialog(
        stationName: widget.viewModel.currentStation?.name ?? 'Station',
        onBackToMap: () {
          Navigator.of(context)
            ..pop() // dialog
            ..pop() // booking screen
            ..pop(); // station detail
        },
      ),
    );
  }
}
