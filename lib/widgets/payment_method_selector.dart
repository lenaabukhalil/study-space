import 'package:flutter/material.dart';

import '../models/payment_method.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const PaymentMethodSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const Map<String, IconData> _icons = {
    PaymentMethods.frontDesk: Icons.storefront,
    PaymentMethods.cardOnArrival: Icons.credit_card,
  };

  @override
  Widget build(BuildContext context) {
    return RadioGroup<String>(
      groupValue: value,
      onChanged: (selected) {
        if (selected != null) {
          onChanged(selected);
        }
      },
      child: Column(
        children: PaymentMethods.all
            .map(
              (method) => RadioListTile<String>(
                value: method,
                title: Text(method),
                secondary: Icon(_icons[method]),
                contentPadding: EdgeInsets.zero,
              ),
            )
            .toList(),
      ),
    );
  }
}
