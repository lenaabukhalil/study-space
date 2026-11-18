import 'package:flutter/material.dart';

class PriceText extends StatelessWidget {
  final String text;
  final bool large;
  final TextAlign? textAlign;

  const PriceText({
    super.key,
    required this.text,
    this.large = false,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = large
        ? theme.textTheme.titleLarge
        : theme.textTheme.labelLarge;

    return Text(
      text,
      textAlign: textAlign,
      style: base?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
