import 'package:flutter/material.dart';

class RoomImage extends StatelessWidget {
  final String imagePath;
  final double? height;

  const RoomImage({super.key, required this.imagePath, this.height});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      height: height ?? double.infinity,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _fallback(context),
    );
  }

  Widget _fallback(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: height ?? double.infinity,
      width: double.infinity,
      color: scheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(Icons.chair_alt, size: 48, color: scheme.onSurfaceVariant),
    );
  }
}
