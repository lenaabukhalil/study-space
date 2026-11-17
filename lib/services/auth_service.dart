import 'package:firebase_auth/firebase_auth.dart';

import 'firestore_service.dart';

class AuthException implements Exception {
  final String message;
  final bool isCredentialError;

  const AuthException(this.message, {this.isCredentialError = false});

  @override
  String toString() => message;
}

class AuthService {
  final FirebaseAuth _auth;
  final FirestoreService _firestore;

  AuthService({FirebaseAuth? auth, FirestoreService? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirestoreService();

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<User?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        await user.updateDisplayName(name.trim());
        await _firestore.createUserProfile(
          uid: user.uid,
          name: name.trim(),
          email: email.trim(),
        );
        await user.reload();
      }
      return _auth.currentUser;
    } on FirebaseAuthException catch (e) {
      throw _exceptionFor(e.code);
    } catch (_) {
      throw const AuthException('Something went wrong. Please try again.');
    }
  }

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _exceptionFor(e.code);
    } catch (_) {
      throw const AuthException('Something went wrong. Please try again.');
    }
  }

  Future<void> signOut() => _auth.signOut();

  static const Set<String> _credentialErrorCodes = {
    'user-not-found',
    'wrong-password',
    'invalid-credential',
  };

  AuthException _exceptionFor(String code) {
    if (_credentialErrorCodes.contains(code)) {
      return const AuthException(
        "Incorrect email or password. Don't have an account? Sign up.",
        isCredentialError: true,
      );
    }
    return AuthException(_messageFor(code));
  }

  String _messageFor(String code) {
    switch (code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'No internet connection. Please check your network.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
