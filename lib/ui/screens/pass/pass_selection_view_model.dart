import 'package:flutter/material.dart';
import 'package:velotoulouse/data/repositories/pass/pass_repository.dart';
import 'package:velotoulouse/data/repositories/payment/payment_repository.dart';
import 'package:velotoulouse/model/pass/pass.dart';
import 'package:velotoulouse/model/payment/payment.dart';
import 'package:velotoulouse/ui/states/view_state.dart';

class PassSelectionViewModel extends ChangeNotifier {
  final PassRepository _passRepository;
  final PaymentRepository _paymentRepository;

  ViewState _state = ViewState.idle;
  PassType? _selectedPassType;
  Pass? _activePass;
  String? _errorMessage;

  static const Map<PassType, double> prices = {
    PassType.day: 1.50,
    PassType.monthly: 15.00,
    PassType.annual: 99.00,
  };

  static const Map<PassType, String> descriptions = {
    PassType.day: 'Valid for 24 hours from activation',
    PassType.monthly: 'Valid for 30 days from activation',
    PassType.annual: 'Valid for 365 days from activation',
  };

  static const Map<PassType, String> durations = {
    PassType.day: '24h',
    PassType.monthly: '30 days',
    PassType.annual: '1 year',
  };

  ViewState get state => _state;
  PassType? get selectedPassType => _selectedPassType;
  Pass? get activePass => _activePass;
  String? get errorMessage => _errorMessage;

  PassSelectionViewModel(this._passRepository, this._paymentRepository);

  // Load active pass for user
  Future<void> loadActivePass(String userId) async {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _activePass = await _passRepository.getActivePass(userId);
      _state = ViewState.success;
    } catch (e) {
      _errorMessage = 'Failed to load active pass: ${e.toString()}';
      _state = ViewState.error;
    }

    notifyListeners();
  }

  // Select a pass type
  void selectPassType(PassType type) {
    if (_activePass != null &&
        _activePass!.isActive &&
        _activePass!.type == type) {
      _errorMessage = 'You already have an active ${type.name} pass';
      return;
    }

    _selectedPassType = type;
    _errorMessage = null;
    notifyListeners();
  }

  // Initiate payment for selected pass
  Future<Payment?> initiatePayment(
    String userId,
    PaymentMethod method,
  ) async {
    if (_selectedPassType == null) {
      _errorMessage = 'Please select a pass type';
      notifyListeners();
      return null;
    }

    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final amount = prices[_selectedPassType]!;
      final payment = await _paymentRepository.processPayment(
        userId: userId,
        amount: amount,
        method: method,
        purpose: _mapPassTypeToPurpose(_selectedPassType!),
      );

      _state = ViewState.success;
      notifyListeners();
      return payment;
    } catch (e) {
      _errorMessage = 'Payment failed: ${e.toString()}';
      _state = ViewState.error;
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
