import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';

class FavoriteButton extends StatelessWidget {
  final String roomId;
  final bool onImage;

  const FavoriteButton({super.key, required this.roomId, this.onImage = false});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isFavorite = context.select<FavoritesProvider, bool>(
      (favorites) => favorites.isFavorite(roomId),
    );

    return IconButton(
      tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
      onPressed: () => context.read<FavoritesProvider>().toggle(roomId),
      style: onImage
          ? IconButton.styleFrom(backgroundColor: scheme.surface)
          : null,
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? scheme.primary : scheme.onSurfaceVariant,
      ),
    );
  }
}
