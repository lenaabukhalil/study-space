import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';

class WeatherRow extends StatelessWidget {
  final DateTime date;

  const WeatherRow({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final textStyle = theme.textTheme.bodyMedium?.copyWith(color: muted);
    final weather = context.watch<WeatherProvider>();
    final forecast = weather.forecastFor(date);

    if (weather.isLoading && forecast == null) {
      return Row(
        children: [
          SizedBox.square(
            dimension: 14,
            child: CircularProgressIndicator(strokeWidth: 2, color: muted),
          ),
          const SizedBox(width: 8),
          Text('Loading weather', style: textStyle),
        ],
      );
    }

    if (weather.errorMessage != null && forecast == null) {
      return Row(
        children: [
          Icon(Icons.cloud_off, size: 18, color: muted),
          const SizedBox(width: 8),
          Text('Weather unavailable', style: textStyle),
          IconButton(
            tooltip: 'Retry',
            visualDensity: VisualDensity.compact,
            iconSize: 18,
            color: muted,
            onPressed: weather.retry,
            icon: const Icon(Icons.refresh),
          ),
        ],
      );
    }

    if (forecast == null) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Icon(forecast.icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(child: Text(forecast.summary, style: textStyle)),
      ],
    );
  }
}
