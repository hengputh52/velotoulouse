import 'package:flutter/material.dart';
import 'package:velotoulouse/data/repositories/pass/pass_repository.dart';
import 'package:velotoulouse/data/repositories/payment/payment_repository.dart';
import 'package:velotoulouse/model/pass/pass.dart';
import 'package:velotoulouse/model/payment/payment.dart';
import 'package:velotoulouse/ui/states/view_state.dart';

class PaymentViewModel extends ChangeNotifier {
  final PaymentRepository _paymentRepository;
  final PassRepository _passRepository;

  ViewState _state = ViewState.loading;
  PaymentMethod _selectedMethod = PaymentMethod.card;
  Payment? _completedPayment;
  String? _errorMessage;

  late PaymentPurpose _purpose;
  late double _amount;
  String? _pendingSlotId;

  ViewState get state => _state;
  PaymentMethod get selectedMethod => _selectedMethod;
  Payment? get completedPayment => _completedPayment;
  String? get errorMessage => _errorMessage;
  double get amount => _amount;
  PaymentPurpose get purpose => _purpose;

  PaymentViewModel(
    this._paymentRepository,
    this._passRepository,
  );

  // Initialize with route parameters
  void init({
    required PaymentPurpose purpose,
    required double amount,
    String? slotId,
  }) {
    _purpose = purpose;
    _amount = amount;
    _pendingSlotId = slotId;
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();
  }

  // Select payment method
  void selectMethod(PaymentMethod method) {
    _selectedMethod = method;
    notifyListeners();
  }

  // Process payment
  Future<void> processPayment(String userId) async {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Step 1: Create payment record
      _completedPayment = await _paymentRepository.processPayment(
        userId: userId,
        amount: _amount,
        method: _selectedMethod,
        purpose: _purpose,
      );

      if (_completedPayment?.isSuccessful != true) {
        throw Exception('Payment processing failed');
      }

      // Step 2: If pass purchase, create pass record
      if (_purpose == PaymentPurpose.dayPass ||
          _purpose == PaymentPurpose.monthlyPass ||
          _purpose == PaymentPurpose.annualPass) {
        // Map purpose to passtype
        final passType = _mapPurposeToPassType(_purpose);
        await _passRepository.purchasePass(
          userId,
          passType,
          _completedPayment!.id,
        );
      }

      // Step 3: If slot booking, create booking record
      if (_pendingSlotId != null) {
        // Will be implemented when booking is integrated
        // await _bookingRepository.createBooking(...)
      }

      _state = ViewState.success;
    } catch (e) {
      _errorMessage = _mapErrorMessage(e.toString());
      _state = ViewState.error;
    }

    notifyListeners();
  }

  // Helper: Map PaymentPurpose to PassType
  PassType _mapPurposeToPassType(PaymentPurpose purpose) {
    return switch (purpose) {
      PaymentPurpose.dayPass => PassType.day,
      PaymentPurpose.monthlyPass => PassType.monthly,
      PaymentPurpose.annualPass => PassType.annual,
      _ => PassType.day,
    };
  }

  // Error mapping
  String _mapErrorMessage(String error) {
    if (error.contains('network')) {
      return 'Network error. Please check your connection and try again';
    } else if (error.contains('card')) {
      return 'Card declined. Please check your card details';
    }
    return 'Payment failed. Please try again';
  }
}
