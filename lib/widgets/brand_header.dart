import 'package:flutter/material.dart';

import '../config/space_info.dart';
import 'brand_logo.dart';

class BrandHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const BrandHeader({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = theme.textTheme.bodyMedium?.copyWith(
      color: scheme.onSurfaceVariant,
    );

    return Column(
      children: [
        const BrandLogo(),
        const SizedBox(height: 16),
        Text(
          SpaceInfo.name,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: scheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(SpaceInfo.tagline, textAlign: TextAlign.center, style: muted),
        const SizedBox(height: 32),
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(subtitle!, textAlign: TextAlign.center, style: muted),
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}
