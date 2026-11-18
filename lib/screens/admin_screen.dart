import 'package:flutter/material.dart';

import '../widgets/admin_bookings_tab.dart';
import '../widgets/admin_rooms_tab.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.meeting_room), text: 'Rooms'),
              Tab(icon: Icon(Icons.event_note), text: 'Bookings'),
            ],
          ),
        ),
        body: const TabBarView(children: [AdminRoomsTab(), AdminBookingsTab()]),
      ),
    );
  }
}
