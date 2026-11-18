import 'package:flutter/material.dart';

import 'content_width.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AdminAppBar({super.key});

  static const double _tabHeight = 48;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + _tabHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Admin'),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(_tabHeight),
        child: ContentWidth(
          child: TabBar(
            tabs: [
              Tab(text: 'Rooms', height: _tabHeight),
              Tab(text: 'Bookings', height: _tabHeight),
            ],
          ),
        ),
      ),
    );
  }
}
