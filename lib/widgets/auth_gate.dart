import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _showLogin = true;

  void _toggle() {
    context.read<AuthProvider>().clearError();
    setState(() {
      _showLogin = !_showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.isInitializing && !auth.isSignedIn) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (auth.isSignedIn) {
      return const HomeScreen();
    }

    return _showLogin
        ? LoginScreen(onSwitchToSignUp: _toggle)
        : SignUpScreen(onSwitchToLogin: _toggle);
  }
}
