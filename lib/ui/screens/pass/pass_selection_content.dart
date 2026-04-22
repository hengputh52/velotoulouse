import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velotoulouse/data/repositories/booking/booking_repository.dart';
import 'package:velotoulouse/data/repositories/pass/pass_repository.dart';
import 'package:velotoulouse/data/repositories/payment/payment_repository.dart';
import 'package:velotoulouse/model/pass/pass.dart';
import 'package:velotoulouse/model/payment/payment.dart';
import 'package:velotoulouse/ui/screens/auth/auth_view_model.dart';
import 'package:velotoulouse/ui/screens/pass/pass_selection_view_model.dart';
import 'package:velotoulouse/ui/screens/pass/widgets/active_pass_banner.dart';
import 'package:velotoulouse/ui/screens/pass/widgets/pass_price_tag.dart';
import 'package:velotoulouse/ui/screens/pass/widgets/pass_type_card.dart';
import 'package:velotoulouse/ui/screens/payment/payment_screen.dart';
import 'package:velotoulouse/ui/screens/payment/payment_view_model.dart';
import 'package:velotoulouse/ui/states/view_state.dart';
import 'package:velotoulouse/ui/theme/theme.dart';
import 'package:velotoulouse/ui/widgets/app_error_banner.dart';
import 'package:velotoulouse/ui/widgets/app_primary_button.dart';

class PassSelectionContent extends StatefulWidget {
  const PassSelectionContent({super.key});

  void _navigateToPayment(BuildContext context, PassSelectionViewModel vm) {
    if (vm.selectedPassType == null) return;

    final selectedPassType = vm.selectedPassType!;
    final paymentPurpose =
        vm.mapPassTypeToPurpose(selectedPassType) as PaymentPurpose;
    final amount = selectedPassType.price;

    // Get repositories from provider
    final paymentRepository = context.read<PaymentRepository>();
    final passRepository = context.read<PassRepository>();
    final bookingRepository = context.read<BookingRepository>();

    // Create PaymentViewModel instance
    final paymentVM = PaymentViewModel(
      paymentRepository,
      passRepository,
      bookingRepository,
    );

    // Initialize payment with selected pass details
    paymentVM.init(purpose: paymentPurpose, amount: amount);

    // Navigate to payment screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PaymentScreen(viewModel: paymentVM)),
    );
  }

  @override
  State<PassSelectionContent> createState() => _PassSelectionContentState();
}

class _PassSelectionContentState extends State<PassSelectionContent> {
  @override
  void initState() {
    super.initState();
    _initializePassSelection();
  }

  void _initializePassSelection() {
    final authVM = context.read<AuthViewModel>();
    final userId = authVM.currentUser?.id ?? '';

    if (userId.isNotEmpty) {
      final passVM = context.read<PassSelectionViewModel>();
      passVM.loadActivePass(userId);
    }
  }

  void _goToPayment(BuildContext context, PassSelectionViewModel vm) {
    final authVM = context.read<AuthViewModel>();
    final userId = authVM.currentUser?.id ?? '';

    if (userId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not authenticated')));
      return;
    }

    if (vm.selectedPassType == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a pass')));
      return;
    }

    // Map PassType to PaymentPurpose
    final purposeMap = {
      PassType.day: PaymentPurpose.dayPass,
      PassType.monthly: PaymentPurpose.monthlyPass,
      PassType.annual: PaymentPurpose.annualPass,
    };

    final purpose = purposeMap[vm.selectedPassType]!;
    final amount = PassSelectionViewModel.prices[vm.selectedPassType] ?? 0;

    // Initialize PaymentViewModel
    final paymentVM = context.read<PaymentViewModel>();
    paymentVM.init(
      purpose: purpose,
      amount: amount,
      stationId: null, // null stationId for pass flow
    );

    // Navigate to Payment Screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaymentScreen(viewModel: paymentVM),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    PassSelectionViewModel vm = context.watch<PassSelectionViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Choose a Pass',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppSpacings.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Active Pass Banner
                  if (vm.activePass != null && vm.activePass!.isActive)
                    Column(
                      children: [
                        ActivePassBanner(pass: vm.activePass!),
                        SizedBox(height: AppSpacings.l),
                      ],
                    ),

                  // Error Banner
                  if (vm.errorMessage != null && vm.state != ViewState.loading)
                    Column(
                      children: [
                        AppErrorBanner(message: vm.errorMessage!),
                        SizedBox(height: AppSpacings.m),
                      ],
                    ),

                  // Pass Type Cards
                  Text(
                    'Select Your Plan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: AppSpacings.m),
                  Column(
                    children: PassType.values.map((type) {
                      final isSelected = vm.selectedPassType == type;
                      final isCurrentPlan =
                          vm.activePass != null &&
                          vm.activePass!.isActive &&
                          vm.activePass!.type == type;

                      return Column(
                        children: [
                          PassTypeCard(
                            type: type,
                            price: type.price,
                            description: type.description,
                            duration: type.duration,
                            isSelected: isSelected,
                            isCurrentPlan: isCurrentPlan,
                            onTap: () => vm.selectPassType(type),
                          ),
                          SizedBox(height: AppSpacings.m),
                        ],
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 120),
                ],
              ),
            ),
          ),

          // Bottom Sticky Bar
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (vm.selectedPassType != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PassPriceTag(
                          amount: PassSelectionViewModel
                              .prices[vm.selectedPassType]!,
                          label: 'Total',
                        ),
                        SizedBox(height: AppSpacings.m),
                      ],
                    ),
                  AppPrimaryButton(
                    label: 'Continue to Payment',
                    isLoading: vm.state == ViewState.loading,
                    onPressed: vm.selectedPassType != null
                        ? () => _goToPayment(context, vm)
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
