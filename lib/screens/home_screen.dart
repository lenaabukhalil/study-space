import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'admin_screen.dart';
import 'my_bookings_screen.dart';
import 'profile_screen.dart';
import 'rooms_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const List<Widget> _customerScreens = [
    RoomsScreen(),
    MyBookingsScreen(),
    ProfileScreen(),
  ];

  static const List<BottomNavigationBarItem> _customerItems = [
    BottomNavigationBarItem(icon: Icon(Icons.meeting_room), label: 'Rooms'),
    BottomNavigationBarItem(icon: Icon(Icons.event_note), label: 'My Bookings'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  ];

  static const BottomNavigationBarItem _adminItem = BottomNavigationBarItem(
    icon: Icon(Icons.admin_panel_settings),
    label: 'Admin',
  );

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.select<AuthProvider, bool>((auth) => auth.isAdmin);
    final screens = [..._customerScreens, if (isAdmin) const AdminScreen()];
    final items = [..._customerItems, if (isAdmin) _adminItem];
    final index = _currentIndex < screens.length ? _currentIndex : 0;

    return Scaffold(
      body: IndexedStack(index: index, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        items: items,
      ),
    );
  }
}
