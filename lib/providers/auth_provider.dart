import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final FirestoreService _firestore;
  late final StreamSubscription<User?> _subscription;
  StreamSubscription<String?>? _roleSubscription;

  User? _user;
  String? _roleUid;
  String? _role;
  bool _isInitializing = true;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isCredentialError = false;

  AuthProvider({AuthService? authService, FirestoreService? firestore})
    : _authService = authService ?? AuthService(),
      _firestore = firestore ?? FirestoreService() {
    _user = _authService.currentUser;
    _watchRole(_user?.uid);
    _subscription = _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  User? get user => _user;
  bool get isSignedIn => _user != null;
  bool get isInitializing => _isInitializing;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isCredentialError => _isCredentialError;
  String? get role => _role;
  bool get isAdmin => _role == 'admin';

  void _onAuthStateChanged(User? user) {
    _user = user;
    _isInitializing = false;
    _watchRole(user?.uid);
    notifyListeners();
  }

  void _watchRole(String? uid) {
    if (_roleUid == uid) {
      return;
    }
    _roleUid = uid;
    _roleSubscription?.cancel();
    _roleSubscription = null;
    _role = null;
    if (uid == null) {
      return;
    }
    _roleSubscription = _firestore
        .watchUserRole(uid)
        .listen(_setRole, onError: (Object _) => _setRole(null));
  }

  void _setRole(String? role) {
    if (_role == role) {
      return;
    }
    _role = role;
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
        _watchRole(user.uid);
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
    _roleSubscription?.cancel();
    super.dispose();
  }
}
