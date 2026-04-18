import 'package:flutter/material.dart';
import 'package:velotoulouse/data/repositories/user/user_repository.dart';
import 'package:velotoulouse/model/user/user.dart';
import 'package:velotoulouse/ui/states/view_state.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  ViewState _state = ViewState.idle;
  AppUser? _currentUser;
  String? _errorMessage;
  bool _isLoginMode = true;
  bool _obscurePassword = true;

  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  ViewState get state => _state;
  AppUser? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoginMode => _isLoginMode;
  bool get obscurePassword => _obscurePassword;

  TextEditingController get displayNameController => _displayNameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get nameController => _nameController;

  AuthViewModel(this._authRepository);

  // Initialize by listening to auth state stream
  void initAuthListener() {
    _authRepository.watchAuthState().listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  // Toggle between login and register modes
  void toggleMode() {
    _isLoginMode = !_isLoginMode;
    _errorMessage = null;
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
      _errorMessage = 'Please enter a valid email address';
      return false;
    }

    if (password.length < 6) {
      _errorMessage = 'Password must be at least 6 characters';
      return false;
    }

    if (!_isLoginMode) {
      final name = _nameController.text.trim();
      if (name.isEmpty) {
        _errorMessage = 'Please enter your display name';
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

    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_isLoginMode) {
        _currentUser = await _authRepository.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
        if (_currentUser == null) {
          _errorMessage = 'No account with that email or incorrect password';
          _state = ViewState.error;
        } else {
          _state = ViewState.success;
        }
      } else {
        _currentUser = await _authRepository.registerWithEmail(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
        );
        _state = ViewState.success;
      }
    } catch (e) {
      _errorMessage = _mapErrorMessage(e.toString());
      _state = ViewState.error;
    }

    notifyListeners();
  }

  // Sign out
  Future<void> signOut() async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      await _authRepository.signOut();
      _currentUser = null;
      _state = ViewState.idle;
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
    } catch (e) {
      _errorMessage = 'Failed to sign out';
      _state = ViewState.error;
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
