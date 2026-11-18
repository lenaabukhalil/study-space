import 'package:flutter/material.dart';

import '../models/weather_forecast.dart';
import 'summary_row.dart';

class WeatherSummaryRow extends StatelessWidget {
  final WeatherForecast forecast;

  const WeatherSummaryRow({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return SummaryRow(
      icon: forecast.icon,
      label: 'Weather',
      value: forecast.summary,
    );
  }
}
