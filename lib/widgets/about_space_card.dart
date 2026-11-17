import 'package:flutter/material.dart';

import '../config/space_info.dart';

class AboutSpaceCard extends StatelessWidget {
  const AboutSpaceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                'About the space',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListTile(
              leading: Icon(Icons.location_on, color: primary),
              title: const Text(SpaceInfo.name),
              subtitle: const Text(SpaceInfo.address),
            ),
            ListTile(
              leading: Icon(Icons.schedule, color: primary),
              title: const Text('Opening hours'),
              subtitle: Text(
                OpeningHours.schedule
                    .map((entry) => '${entry.$1}: ${entry.$2.label}')
                    .join('\n'),
              ),
              isThreeLine: true,
            ),
          ],
        ),
      ),
    );
  }
}
