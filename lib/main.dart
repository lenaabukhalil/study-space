import 'package:flutter/material.dart';

import 'screens/rooms_screen.dart';

void main() {
  runApp(const StudySpaceApp());
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
      home: const RoomsScreen(),
    );
  }
}
