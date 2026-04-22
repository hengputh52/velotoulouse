import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velotoulouse/ui/screens/payment/payment_content.dart';
import 'package:velotoulouse/ui/screens/payment/view_model/payment_view_model.dart';

class PaymentScreen extends StatelessWidget {
  final PaymentViewModel viewModel;

  const PaymentScreen({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: const PaymentContent(),
    );
  }
}
