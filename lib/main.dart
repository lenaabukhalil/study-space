import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/space_info.dart';
import 'firebase_options.dart';
import 'providers/admin_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/rooms_provider.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'theme/app_theme.dart';
import 'widgets/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final firestore = FirestoreService();
  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: firestore),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            authService: AuthService(firestore: firestore),
            firestore: firestore,
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, RoomsProvider>(
          create: (_) => RoomsProvider(firestore),
          update: (_, auth, rooms) =>
              (rooms ?? RoomsProvider(firestore))..updateUser(auth.user?.uid),
        ),
        ChangeNotifierProxyProvider<AuthProvider, BookingProvider>(
          create: (_) => BookingProvider(firestore),
          update: (_, auth, bookings) =>
              (bookings ?? BookingProvider(firestore))..updateUser(
                auth.user?.uid,
                name: auth.user?.displayName,
                email: auth.user?.email,
              ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, AdminProvider>(
          create: (_) => AdminProvider(firestore),
          update: (_, auth, admin) =>
              (admin ?? AdminProvider(firestore))..updateAdmin(auth.isAdmin),
        ),
      ],
      child: const YasmineWorkspaceApp(),
    ),
  );
}

class YasmineWorkspaceApp extends StatelessWidget {
  const YasmineWorkspaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: SpaceInfo.name,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const AuthGate(),
    );
  }
}
