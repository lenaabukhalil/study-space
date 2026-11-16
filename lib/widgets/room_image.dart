import 'package:flutter/material.dart';

class RoomImage extends StatelessWidget {
  final String imageUrl;
  final double height;

  const RoomImage({super.key, required this.imageUrl, this.height = 160});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return _placeholder(const CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) {
        return _placeholder(
          Icon(Icons.broken_image, size: 48, color: Colors.grey.shade500),
        );
      },
    );
  }

  Widget _placeholder(Widget child) {
    return Container(
      height: height,
      width: double.infinity,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: child,
    );
  }
}
