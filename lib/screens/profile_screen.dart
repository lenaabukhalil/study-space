import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/about_space_card.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/content_width.dart';
import '../widgets/logout_button.dart';
import '../widgets/profile_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Log out?',
      message: 'Are you sure you want to log out?',
    );

    if (!confirmed || !context.mounted) {
      return;
    }

    await context.read<AuthProvider>().signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final name = user?.displayName?.trim();
    final displayName = name == null || name.isEmpty ? 'Yasmine member' : name;
    final email = user?.email ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ContentWidth(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          children: [
            ProfileHeader(name: displayName, email: email),
            const SizedBox(height: 32),
            const AboutSpaceCard(),
            const SizedBox(height: 24),
            LogoutButton(onPressed: () => _confirmLogout(context)),
          ],
        ),
      ),
    );
  }
}
