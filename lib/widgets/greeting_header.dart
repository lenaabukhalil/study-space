import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/space_info.dart';
import '../providers/auth_provider.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({super.key});

  String _timeGreeting(DateTime now) {
    if (now.hour < 12) {
      return 'Good morning';
    }
    if (now.hour < 17) {
      return 'Good afternoon';
    }
    return 'Good evening';
  }

  String? _firstName(String? displayName) {
    final name = displayName?.trim() ?? '';
    if (name.isEmpty) {
      return null;
    }
    return name.split(RegExp(r'\s+')).first;
  }

  @override
  Widget build(BuildContext context) {
    final displayName = context.select<AuthProvider, String?>(
      (auth) => auth.user?.displayName,
    );
    final firstName = _firstName(displayName);
    final greeting = _timeGreeting(DateTime.now());
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          SpaceInfo.name.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
            color: scheme.primary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          firstName == null ? greeting : '$greeting, $firstName',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 4),
        Text(
          'Find your space in ${SpaceInfo.area}',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
