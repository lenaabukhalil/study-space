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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          SpaceInfo.name.toUpperCase(),
          style: theme.textTheme.labelLarge?.copyWith(
            letterSpacing: 1.2,
            color: scheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          firstName == null ? greeting : '$greeting, $firstName',
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Find your space in ${SpaceInfo.area}',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
