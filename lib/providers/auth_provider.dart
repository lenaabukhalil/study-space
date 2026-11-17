import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  late final StreamSubscription<User?> _subscription;

  User? _user;
  bool _isInitializing = true;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isCredentialError = false;

  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService() {
    _user = _authService.currentUser;
    _subscription = _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  User? get user => _user;
  bool get isSignedIn => _user != null;
  bool get isInitializing => _isInitializing;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isCredentialError => _isCredentialError;

  void _onAuthStateChanged(User? user) {
    _user = user;
    _isInitializing = false;
    notifyListeners();
  }

  Future<bool> signIn({required String email, required String password}) {
    return _run(() => _authService.signIn(email: email, password: password));
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) {
    return _run(
      () => _authService.signUp(name: name, email: email, password: password),
    );
  }

  Future<void> signOut() async {
    _errorMessage = null;
    _isCredentialError = false;
    await _authService.signOut();
  }

  void clearError() {
    if (_errorMessage == null) {
      return;
    }
    _errorMessage = null;
    _isCredentialError = false;
    notifyListeners();
  }

  Future<bool> _run(Future<User?> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    _isCredentialError = false;
    notifyListeners();
    try {
      final user = await action();
      if (user != null) {
        _user = user;
      }
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _isCredentialError = e.isCredentialError;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
