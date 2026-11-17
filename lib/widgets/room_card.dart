import 'package:flutter/material.dart';

import '../models/room.dart';
import '../screens/room_details_screen.dart';
import '../utils/formatters.dart';
import 'amenity_chips.dart';
import 'room_image.dart';

class RoomCard extends StatelessWidget {
  final Room room;

  const RoomCard({super.key, required this.room});

  void _openDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RoomDetailsScreen(room: room)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openDetails(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: RoomImage(imagePath: room.imagePath)),
            Padding(
              padding: const EdgeInsets.all(12),
              child: _RoomCardDetails(room: room),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomCardDetails extends StatelessWidget {
  final Room room;

  const _RoomCardDetails({required this.room});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          room.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.people, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                Formatters.capacity(room.capacity),
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ),
            Text(
              Formatters.pricePerHour(room.pricePerHour),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: scheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AmenityChips(amenities: room.amenities, maxCount: 3),
      ],
    );
  }
}
