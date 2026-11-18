import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/app_navigation_bar.dart';
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

  static const List<NavigationDestination> _customerDestinations = [
    NavigationDestination(
      icon: Icon(Icons.meeting_room_outlined),
      selectedIcon: Icon(Icons.meeting_room),
      label: 'Rooms',
    ),
    NavigationDestination(
      icon: Icon(Icons.event_note_outlined),
      selectedIcon: Icon(Icons.event_note),
      label: 'My Bookings',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  static const NavigationDestination _adminDestination = NavigationDestination(
    icon: Icon(Icons.admin_panel_settings_outlined),
    selectedIcon: Icon(Icons.admin_panel_settings),
    label: 'Admin',
  );

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.select<AuthProvider, bool>((auth) => auth.isAdmin);
    final screens = [..._customerScreens, if (isAdmin) const AdminScreen()];
    final destinations = [
      ..._customerDestinations,
      if (isAdmin) _adminDestination,
    ];
    final index = _currentIndex < screens.length ? _currentIndex : 0;

    return Scaffold(
      body: IndexedStack(index: index, children: screens),
      bottomNavigationBar: AppNavigationBar(
        selectedIndex: index,
        destinations: destinations,
        onSelected: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
    );
  }
}
