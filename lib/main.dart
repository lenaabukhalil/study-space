import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/rooms_provider.dart';
import 'widgets/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RoomsProvider()),
        ChangeNotifierProxyProvider<AuthProvider, BookingProvider>(
          create: (_) => BookingProvider(),
          update: (_, auth, bookings) =>
              (bookings ?? BookingProvider())..updateUser(auth.user?.uid),
        ),
      ],
      child: const StudySpaceApp(),
    ),
  );
}

class StudySpaceApp extends StatelessWidget {
  const StudySpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudySpace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const AuthGate(),
    );
  }
}
