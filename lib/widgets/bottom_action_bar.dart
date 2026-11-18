import 'package:flutter/material.dart';

import '../theme/app_layout.dart';
import 'content_width.dart';

class BottomActionBar extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const BottomActionBar({
    super.key,
    required this.child,
    this.maxWidth = AppLayout.contentMaxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: ContentWidth(maxWidth: maxWidth, heightFactor: 1, child: child),
      ),
    );
  }
}
