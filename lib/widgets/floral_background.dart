import 'package:flutter/material.dart';

class FloralBackground extends StatelessWidget {
  final Widget child;

  const FloralBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary.withValues(alpha: 0.06);

    return Stack(
      fit: StackFit.expand,
      children: [
        IgnorePointer(
          child: Stack(
            children: [
              _Flower(top: -32, left: -32, size: 152, color: color),
              _Flower(top: 112, left: 24, size: 40, color: color),
              _Flower(top: -8, right: -24, size: 88, color: color),
              _Flower(top: 72, right: 72, size: 32, color: color),
              _Flower(bottom: -40, right: -40, size: 168, color: color),
              _Flower(bottom: 120, right: 32, size: 48, color: color),
              _Flower(bottom: 24, left: -8, size: 80, color: color),
            ],
          ),
        ),
        child,
      ],
    );
  }
}

class _Flower extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double size;
  final Color color;

  const _Flower({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Icon(Icons.local_florist, size: size, color: color),
    );
  }
}
