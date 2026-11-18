import 'package:flutter/material.dart';

import '../theme/app_layout.dart';

class ContentWidth extends StatelessWidget {
  final double maxWidth;
  final bool padded;
  final Widget child;

  const ContentWidth({
    super.key,
    this.maxWidth = AppLayout.contentMaxWidth,
    this.padded = true,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: padded
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppLayout.gutter,
                ),
                child: child,
              )
            : child,
      ),
    );
  }
}
