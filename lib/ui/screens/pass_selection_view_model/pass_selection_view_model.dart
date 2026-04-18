import 'package:flutter/material.dart';
import 'package:velotoulouse/data/repositories/pass/pass_repository.dart';
import 'package:velotoulouse/data/repositories/payment/payment_repository.dart';
import 'package:velotoulouse/model/pass/pass.dart';
import 'package:velotoulouse/model/payment/payment.dart';
import 'package:velotoulouse/ui/states/pass_state.dart';
import 'package:velotoulouse/ui/states/view_state.dart';

class PassSelectionViewModel extends ChangeNotifier {
  final PassRepository _passRepository;
  final PaymentRepository _paymentRepository;
  final PassState _passState;

  // Getters from global PassState
  ViewState get state => _passState.state;
  PassType? get selectedPassType => _passState.selectedPassType;
  Pass? get activePass => _passState.activePass;
  String? get errorMessage => _passState.errorMessage;
  bool get hasActivePass => _passState.hasActivePass;

  PassSelectionViewModel(
    this._passRepository,
    this._paymentRepository,
    this._passState,
  );

  // Load active pass for user
  Future<void> loadActivePass(String userId) async {
    _passState.setState(ViewState.loading);

    notifyListeners();

    try {
      final pass = await _passRepository.getActivePass(userId);
      _passState.setActivePass(pass);
      _passState.setState(ViewState.success);
    } catch (e) {
      _passState.setErrorMessage('Failed to load active pass: ${e.toString()}');
      _passState.setState(ViewState.error);
    }

    notifyListeners();
  }

  // Select a pass type
  void selectPassType(PassType type) {
    if (_passState.hasActivePass && _passState.activePass!.type == type) {
      _passState.setErrorMessage('You already have an active ${type.name} pass');
      return;
    }

    _passState.setSelectedPassType(type);

    notifyListeners();
  }

  // Initiate payment for selected pass
  Future<Payment?> initiatePayment(
    String userId,
    PaymentMethod method,
  ) async {
    if (_passState.selectedPassType == null) {
      _passState.setErrorMessage('Please select a pass type');
      notifyListeners();
      return null;
    }

    _passState.setState(ViewState.loading);

    notifyListeners();

    try {
      final amount = _passState.selectedPassType!.price;
      final payment = await _paymentRepository.processPayment(
        userId: userId,
        amount: amount,
        method: method,
        purpose: _mapPassTypeToPurpose(_passState.selectedPassType!),
      );

      _passState.setState(ViewState.success);
      notifyListeners();
      return payment;
    } catch (e) {
      _passState.setErrorMessage('Payment failed: ${e.toString()}');
      _passState.setState(ViewState.error);
      notifyListeners();
      return null;
    }
  }

  // Helper to map PassType to PaymentPurpose
  PaymentPurpose _mapPassTypeToPurpose(PassType type) {
    return switch (type) {
      PassType.day => PaymentPurpose.dayPass,
      PassType.monthly => PaymentPurpose.monthlyPass,
      PassType.annual => PaymentPurpose.annualPass,
    };
  }
}
