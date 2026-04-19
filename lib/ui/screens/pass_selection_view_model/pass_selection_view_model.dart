import 'package:flutter/material.dart';
import 'package:velotoulouse/data/repositories/pass/pass_repository.dart';
import 'package:velotoulouse/data/repositories/payment/payment_repository.dart';
import 'package:velotoulouse/model/pass/pass.dart';
import 'package:velotoulouse/model/payment/payment.dart';
import 'package:velotoulouse/ui/states/pass_state.dart';
import 'package:velotoulouse/ui/states/view_state.dart';

class PassSelectionViewModel extends ChangeNotifier {
  final PassRepository passRepository;
  final PaymentRepository paymentRepository;
  final PassState passState;

  // Getters from global PassState
  ViewState get state => passState.state;
  PassType? get selectedPassType => passState.selectedPassType;
  Pass? get activePass => passState.activePass;
  String? get errorMessage => passState.errorMessage;
  bool get hasActivePass => passState.hasActivePass;

  PassSelectionViewModel({
    required this.passRepository,
    required this.paymentRepository,
    required this.passState,
  }
  );

  // Load active pass for user
  Future<void> loadActivePass(String userId) async {
    passState.setState(ViewState.loading);

    notifyListeners();

    try {
      final pass = await passRepository.getActivePass(userId);
      passState.setActivePass(pass);
      passState.setState(ViewState.success);
    } catch (e) {
      passState.setErrorMessage('Failed to load active pass: ${e.toString()}');
      passState.setState(ViewState.error);
    }

    notifyListeners();
  }

  // Select a pass type
  void selectPassType(PassType type) {
    if (passState.hasActivePass && passState.activePass!.type == type) {
      passState.setErrorMessage('You already have an active ${type.name} pass');
      return;
    }

    passState.setSelectedPassType(type);

    notifyListeners();
  }

  // Initiate payment for selected pass
  Future<Payment?> initiatePayment(
    String userId,
    PaymentMethod method,
  ) async {
    if (passState.selectedPassType == null) {
      passState.setErrorMessage('Please select a pass type');
      notifyListeners();
      return null;
    }

    passState.setState(ViewState.loading);

    notifyListeners();

    try {
      final amount = passState.selectedPassType!.price;
      final payment = await paymentRepository.processPayment(
        userId: userId,
        amount: amount,
        method: method,
        purpose: mapPassTypeToPurpose(passState.selectedPassType!),
      );

      passState.setState(ViewState.success);
      notifyListeners();
      return payment;
    } catch (e) {
      passState.setErrorMessage('Payment failed: ${e.toString()}');
      passState.setState(ViewState.error);
      notifyListeners();
      return null;
    }
  }

  // Helper to map PassType to PaymentPurpose
  PaymentPurpose mapPassTypeToPurpose(PassType type) {
    return switch (type) {
      PassType.single => PaymentPurpose.singleTicket,
      PassType.day => PaymentPurpose.dayPass,
      PassType.monthly => PaymentPurpose.monthlyPass,
      PassType.annual => PaymentPurpose.annualPass,
    };
  }
}
