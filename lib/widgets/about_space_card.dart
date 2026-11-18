import 'package:flutter/material.dart';

import '../config/space_info.dart';

class AboutSpaceCard extends StatelessWidget {
  const AboutSpaceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(
                'About the space',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const ListTile(
              leading: Icon(Icons.location_on_outlined),
              title: Text(SpaceInfo.name),
              subtitle: Text(SpaceInfo.address),
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
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
