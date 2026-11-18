import 'package:flutter/material.dart';

import '../widgets/admin_bookings_tab.dart';
import '../widgets/admin_rooms_tab.dart';
import '../widgets/admin_tab_bar.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AdminAppBar(),
        body: TabBarView(children: [AdminRoomsTab(), AdminBookingsTab()]),
      ),
    );
  }
}
