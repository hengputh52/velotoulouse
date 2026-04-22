import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velotoulouse/data/repositories/pass/pass_repository.dart';
import 'package:velotoulouse/data/repositories/payment/payment_repository.dart';
import 'package:velotoulouse/ui/screens/pass/pass_selection_view_model.dart';
import 'package:velotoulouse/ui/screens/pass/pass_selection_content.dart';

class PassSelectionScreen extends StatelessWidget {
  const PassSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        try {
          PassSelectionViewModel(
            context.read<PassRepository>(),
            context.read<PaymentRepository>(),
          );
        } catch (e) {
          throw Exception('Pass Selection View model creation error: $e');
        }
      },
      child: const PassSelectionContent(),
    );
  }
}
