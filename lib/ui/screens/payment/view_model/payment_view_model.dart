import 'package:flutter/material.dart';
import 'package:velotoulouse/data/repositories/booking/booking_repository.dart';
import 'package:velotoulouse/data/repositories/pass/pass_repository.dart';
import 'package:velotoulouse/data/repositories/payment/payment_repository.dart';
import 'package:velotoulouse/model/booking/booking.dart';
import 'package:velotoulouse/model/pass/pass.dart';
import 'package:velotoulouse/model/payment/payment.dart';
import 'package:velotoulouse/ui/states/view_state.dart';

class PaymentViewModel extends ChangeNotifier {
  final PaymentRepository _paymentRepository;
  final PassRepository _passRepository;
  final BookingRepository _bookingRepository;

  ViewState _state = ViewState.idle;
  PaymentMethod _selectedMethod = PaymentMethod.card;
  Payment? _completedPayment;
  Booking? _createdBooking;
  String? _errorMessage;

  late PaymentPurpose _purpose;
  late double _amount;
  String? _pendingSlotId;
  String? _pendingStationId;

  ViewState get state => _state;
  PaymentMethod get selectedMethod => _selectedMethod;
  Payment? get completedPayment => _completedPayment;
  Booking? get createdBooking => _createdBooking;
  String? get errorMessage => _errorMessage;
  double get amount => _amount;
  PaymentPurpose get purpose => _purpose;

  PaymentViewModel(
    this._paymentRepository,
    this._passRepository,
    this._bookingRepository,
  );

  void init({
    required PaymentPurpose purpose,
    required double amount,
    String? slotId,
    String? stationId,
  }) {
    _purpose = purpose;
    _amount = amount;
    _pendingSlotId = slotId;
    _pendingStationId = stationId;
    _completedPayment = null;
    _createdBooking = null;
    _state = ViewState.idle;
    _errorMessage = null;
    notifyListeners();
  }

  void selectMethod(PaymentMethod method) {
    _selectedMethod = method;
    notifyListeners();
  }

  Future<void> processPayment(String userId) async {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Step 1: create payment record
      _completedPayment = await _paymentRepository.processPayment(
        userId: userId,
        amount: _amount,
        method: _selectedMethod,
        purpose: _purpose,
      );

      if (_completedPayment?.isSuccessful != true) {
        throw Exception('Payment processing failed. Please try again.');
      }

      // Step 2: if pass purchase → activate pass
      if (_purpose != PaymentPurpose.singleTicket) {
        final passType = _mapPurposeToPassType(_purpose);
        await _passRepository.purchasePass(
          userId,
          passType,
          _completedPayment!.id,
        );
      }

      if (_purpose == PaymentPurpose.singleTicket &&
          _pendingSlotId != null &&
          _pendingStationId != null) {
        final alreadyRiding = await _bookingRepository.hasCurrentBooking(
          userId,
        );
        if (alreadyRiding) {
          // Payment succeeded but booking blocked — inform user clearly
          throw Exception(
            'Payment was successful but you already have an active ride. '
            'Return your current bike, then book again.',
          );
        }

        _createdBooking = await _bookingRepository.createBooking(
          userId: userId,
          bikeSlotId: _pendingSlotId!,
          stationId: _pendingStationId!,
          paymentId: _completedPayment!.id,
          passId: null,
        );
      }

      _state = ViewState.success;
    } catch (e) {
      _errorMessage = _mapErrorMessage(e.toString());
      _state = ViewState.error;
    }

    notifyListeners();
  }

  PassType _mapPurposeToPassType(PaymentPurpose purpose) {
    return switch (purpose) {
      PaymentPurpose.singleTicket => PassType.single,
      PaymentPurpose.dayPass => PassType.day,
      PaymentPurpose.monthlyPass => PassType.monthly,
      PaymentPurpose.annualPass => PassType.annual,
    };
  }

  String _mapErrorMessage(String error) {
    final lower = error.toLowerCase();
    if (lower.contains('network') || lower.contains('socket')) {
      return 'No internet connection. Please check your network and retry.';
    }
    if (lower.contains('card') || lower.contains('declined')) {
      return 'Card declined. Please check your details or try another method.';
    }
    if (lower.contains('current ride') || lower.contains('active ride')) {
      return error.replaceFirst('Exception: ', '');
    }
    return 'Payment failed. Please try again.';
  }
}
