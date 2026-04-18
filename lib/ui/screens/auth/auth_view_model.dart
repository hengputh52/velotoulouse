import 'package:flutter/material.dart';
import 'package:velotoulouse/data/repositories/user/user_repository.dart';
import 'package:velotoulouse/model/user/user.dart';
import 'package:velotoulouse/ui/states/auth_state.dart';
import 'package:velotoulouse/ui/states/view_state.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final AuthState _authState;

  bool _isLoginMode = true;
  bool _obscurePassword = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  // Getters from global AuthState
  ViewState get state => _authState.state;
  AppUser? get currentUser => _authState.currentUser;
  String? get errorMessage => _authState.errorMessage;
  bool get isLoginMode => _isLoginMode;
  bool get obscurePassword => _obscurePassword;

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get nameController => _nameController;

  AuthViewModel(this._authRepository, this._authState);

  // Toggle between login and register modes
  void toggleMode() {
    _isLoginMode = !_isLoginMode;

    _emailController.clear();
    _passwordController.clear();
    _nameController.clear();
    notifyListeners();
  }

  // Toggle password obscurity
  void toggleObscure() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  // Validate form inputs
  bool _validateForm() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (!email.contains('@') || !email.contains('.')) {
      _authState.setErrorMessage('Please enter a valid email address');
      return false;
    }

    if (password.length < 6) {
      _authState.setErrorMessage('Password must be at least 6 characters');
      return false;
    }

    if (!_isLoginMode) {
      final name = _nameController.text.trim();
      if (name.isEmpty) {
        _authState.setErrorMessage('Please enter your display name');
        return false;
      }
    }

    return true;
  }

  // Submit form (sign in or register)
  Future<void> submit() async {
    if (!_validateForm()) {
      notifyListeners();
      return;
    }

    _authState.setState(ViewState.loading);
    notifyListeners();

    try {
      if (_isLoginMode) {
        final user = await _authRepository.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
        if (user == null) {
          _authState.setErrorMessage('No account with that email or incorrect password');
          _authState.setState(ViewState.error);
        } else {
          _authState.setCurrentUser(user);
          _authState.setState(ViewState.success);
        }
      } else {
        final user = await _authRepository.registerWithEmail(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
        );
        _authState.setCurrentUser(user);
        _authState.setState(ViewState.success);
      }
    } catch (e) {
      _authState.setErrorMessage(_mapErrorMessage(e.toString()));
      _authState.setState(ViewState.error);
    }

    notifyListeners();
  }

  // Sign out
  Future<void> signOut() async {
    _authState.setState(ViewState.loading);
    notifyListeners();

    try {
      await _authRepository.signOut();

      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
    } catch (e) {
      _authState.setErrorMessage('Failed to sign out');
      _authState.setState(ViewState.error);
    }

    notifyListeners();
  }

  // Map Firebase error codes to user-friendly messages
  String _mapErrorMessage(String error) {
    if (error.contains('user-not-found')) {
      return 'No account with that email';
    } else if (error.contains('wrong-password')) {
      return 'Incorrect password';
    } else if (error.contains('email-already-in-use')) {
      return 'An account already exists with that email';
    } else if (error.contains('network')) {
      return 'No internet connection';
    }
    return 'Something went wrong. Please try again';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
