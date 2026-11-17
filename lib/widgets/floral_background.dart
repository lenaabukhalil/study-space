import 'package:flutter/material.dart';

class FloralBackground extends StatelessWidget {
  final Widget child;

  const FloralBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final leaf = scheme.primary.withValues(alpha: 0.07);
    final petal = scheme.secondary.withValues(alpha: 0.45);

    return Stack(
      fit: StackFit.expand,
      children: [
        IgnorePointer(
          child: Stack(
            children: [
              _Flower(top: -30, left: -30, size: 150, color: leaf),
              _Flower(top: 110, left: 24, size: 40, color: petal),
              _Flower(top: -10, right: -20, size: 90, color: petal),
              _Flower(top: 70, right: 70, size: 32, color: leaf),
              _Flower(bottom: -40, right: -40, size: 170, color: leaf),
              _Flower(bottom: 120, right: 30, size: 44, color: petal),
              _Flower(bottom: 20, left: -10, size: 80, color: petal),
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
