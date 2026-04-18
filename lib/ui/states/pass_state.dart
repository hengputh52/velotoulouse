import 'package:flutter/material.dart';
import 'package:velotoulouse/model/pass/pass.dart';
import 'package:velotoulouse/ui/states/view_state.dart';

/// Global pass state holder
/// Manages active pass, selected pass type, and pass-related errors
class PassState extends ChangeNotifier {
  Pass? _activePass;
  PassType? _selectedPassType;
  ViewState _state = ViewState.loading;
  String? _errorMessage;

  // Getters
  Pass? get activePass => _activePass;
  PassType? get selectedPassType => _selectedPassType;
  ViewState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get hasActivePass => _activePass != null && _activePass!.isActive;

  // Setters for ViewModel to update state
  void setActivePass(Pass? pass) {
    _activePass = pass;
    notifyListeners();
  }

  void setSelectedPassType(PassType? type) {
    _selectedPassType = type;
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


  void clearSelection() {
    _selectedPassType = null;
    _errorMessage = null;
    notifyListeners();
  }

}