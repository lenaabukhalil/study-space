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
      errorBuilder: (context, error, stackTrace) => _fallbackIcon(),
    );
  }

  Widget _fallbackIcon() {
    return Container(
      height: height ?? double.infinity,
      width: double.infinity,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: Icon(Icons.chair_alt, size: 48, color: Colors.grey.shade500),
    );
  }
}
