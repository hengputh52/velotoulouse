import 'package:flutter/material.dart';
import 'package:velotoulouse/model/user/user.dart';
import 'package:velotoulouse/ui/states/view_state.dart';

/// Global authentication state holder
/// Manages current user, auth status, and error messages
class AuthState extends ChangeNotifier {
  AppUser? _currentUser;
  ViewState _state = ViewState.loading;
  String? _errorMessage;

  // Getters
  AppUser? get currentUser => _currentUser;
  ViewState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  // Setters for ViewModel to update state
  void setCurrentUser(AppUser? user) {
    _currentUser = user;
    notifyListeners();
  }

  void setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }


}
