import 'package:flutter/material.dart';

import '../models/room.dart';
import '../screens/room_details_screen.dart';
import '../utils/formatters.dart';
import 'amenity_chips.dart';
import 'favorite_button.dart';
import 'price_text.dart';
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
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openDetails(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  RoomImage(imagePath: room.imagePath),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: FavoriteButton(roomId: room.id, onImage: true),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
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
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          room.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.people_outline, size: 16, color: muted),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                Formatters.capacity(room.capacity),
                style: theme.textTheme.bodyMedium?.copyWith(color: muted),
              ),
            ),
            PriceText(text: Formatters.pricePerHour(room.pricePerHour)),
          ],
        ),
        const SizedBox(height: 12),
        AmenityChips(amenities: room.amenities, maxCount: 3),
      ],
    );
  }
}
