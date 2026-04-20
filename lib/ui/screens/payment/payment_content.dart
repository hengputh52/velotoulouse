import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velotoulouse/model/payment/payment.dart';
import 'package:velotoulouse/ui/screens/auth/auth_view_model.dart';
import 'package:velotoulouse/ui/screens/payment/payment_view_model.dart';
import 'package:velotoulouse/ui/screens/payment/widgets/order_summary_card.dart';
import 'package:velotoulouse/ui/screens/payment/widgets/payment_method_tile.dart';
import 'package:velotoulouse/ui/screens/payment/widgets/payment_processing_overlay.dart';
import 'package:velotoulouse/ui/states/auth_state.dart';
import 'package:velotoulouse/ui/states/view_state.dart';
import 'package:velotoulouse/ui/theme/theme.dart';
import 'package:velotoulouse/ui/widgets/app_error_banner.dart';
import 'package:velotoulouse/ui/widgets/app_primary_button.dart';

class PaymentContent extends StatelessWidget {
  const PaymentContent({super.key});

  void _processPaymentWithAuth(BuildContext context, PaymentViewModel vm) {
    final authVM = context.read<AuthViewModel>();
    final userId = authVM.currentUser?.id ?? '';
    if (userId.isNotEmpty) {
      vm.processPayment(userId);
    }
  }

  void _showPaymentSuccessDialog(BuildContext context, PaymentViewModel vm) {
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
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 56,
                ),
              ),
              SizedBox(height: AppSpacings.m),
              const Text(
                'Payment Successful!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: AppSpacings.s),
              Text(
                'Amount: \$${vm.amount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 14),
              ),
              SizedBox(height: AppSpacings.l),
              AppPrimaryButton(
                label: 'Continue',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<PaymentViewModel>(
        builder: (context, vm, _) {
          // Handle success state - show dialog
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (vm.state == ViewState.success &&
                vm.completedPayment != null &&
                context.mounted) {
              _showPaymentSuccessDialog(context, vm);
            }
          });

          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacings.l),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Summary
                      OrderSummaryCard(purpose: vm.purpose, amount: vm.amount),
                      SizedBox(height: AppSpacings.l),

                      // Payment Method Section
                      Text(
                        'Choose Payment Method',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: AppSpacings.m),

                      // Payment Method Tiles
                      Column(
                        children: PaymentMethod.values.map((method) {
                          return Column(
                            children: [
                              PaymentMethodTile(
                                method: method,
                                isSelected: vm.selectedMethod == method,
                                onTap: () => vm.selectMethod(method),
                              ),
                              SizedBox(height: AppSpacings.m),
                            ],
                          );
                        }).toList(),
                      ),

                      // Error Banner
                      if (vm.errorMessage != null &&
                          vm.state != ViewState.loading)
                        Column(
                          children: [
                            AppErrorBanner(message: vm.errorMessage!),
                            SizedBox(height: AppSpacings.m),
                          ],
                        ),

                      // Terms Text
                      Text(
                        'By continuing you agree to our terms and conditions',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.secondary,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '\$${vm.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacings.m),
                      AppPrimaryButton(
                        label: 'Pay \$${vm.amount.toStringAsFixed(2)}',
                        isLoading: vm.state == ViewState.loading,
                        onPressed: vm.state != ViewState.loading
                            ? () => _processPaymentWithAuth(context, vm)
                            : null,
                      ),
                    ],
                  ),
                ),
              ),

              // Processing Overlay
              PaymentProcessingOverlay(
                isVisible: vm.state == ViewState.loading,
              ),
            ],
          );
        },
      ),
    );
  }
}
