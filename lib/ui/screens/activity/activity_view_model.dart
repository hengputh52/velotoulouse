import 'package:flutter/material.dart';
import 'package:velotoulouse/data/repositories/booking/booking_repository.dart';
import 'package:velotoulouse/data/repositories/pass/pass_repository.dart';
import 'package:velotoulouse/data/repositories/payment/payment_repository.dart';
import 'package:velotoulouse/model/booking/booking.dart';
import 'package:velotoulouse/model/pass/pass.dart';
import 'package:velotoulouse/model/payment/payment.dart';
import 'package:velotoulouse/ui/states/view_state.dart';

class ActivityViewModel extends ChangeNotifier {
  final BookingRepository _bookingRepository;
  final PassRepository _passRepository;
  final PaymentRepository _paymentRepository;

  ViewState _state = ViewState.idle;
  List<Booking> _bookingHistory = [];
  List<Pass> _passHistory = [];
  List<Payment> _paymentHistory = [];
  String? _errorMessage;
  int _selectedTabIndex = 0;

  ViewState get state => _state;
  List<Booking> get bookingHistory => _bookingHistory;
  List<Pass> get passHistory => _passHistory;
  List<Payment> get paymentHistory => _paymentHistory;
  String? get errorMessage => _errorMessage;
  int get selectedTabIndex => _selectedTabIndex;

  ActivityViewModel(
    this._bookingRepository,
    this._passRepository,
    this._paymentRepository,
  );

  // Load all activity data for user
  Future<void> loadActivity(String userId) async {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Load in parallel
      final results = await Future.wait([
        _loadBookingHistory(userId),
        _loadPassHistory(userId),
        _loadPaymentHistory(userId),
      ]);

      _state = ViewState.success;
    } catch (e) {
      _errorMessage = 'Failed to load activity: ${e.toString()}';
      _state = ViewState.error;
    }

    notifyListeners();
  }

  // Load booking history
  Future<void> _loadBookingHistory(String userId) async {
    try {
      _bookingHistory = await _bookingRepository.getBookingHistory(userId);
    } catch (e) {
      print('Error loading booking history: $e');
    }
  }

  // Load pass history
  Future<void> _loadPassHistory(String userId) async {
    try {
      _passHistory = await _passRepository.getPassHistory(userId);
    } catch (e) {
      print('Error loading pass history: $e');
    }
  }

  // Load payment history
  Future<void> _loadPaymentHistory(String userId) async {
    try {
      _paymentHistory = await _paymentRepository.getPaymentHistory(userId);
    } catch (e) {
      print('Error loading payment history: $e');
    }
  }

  // Select tab
  void selectTab(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  // Retry loading
  Future<void> retry(String userId) async {
    await loadActivity(userId);
  }
}
