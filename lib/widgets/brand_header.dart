import 'package:flutter/material.dart';

import '../config/space_info.dart';

class BrandHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const BrandHeader({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      children: [
        CircleAvatar(
          radius: 38,
          backgroundColor: scheme.secondary,
          child: Icon(Icons.local_florist, size: 40, color: scheme.primary),
        ),
        const SizedBox(height: 14),
        Text(
          SpaceInfo.name,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: scheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          SpaceInfo.tagline,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 32),
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}
