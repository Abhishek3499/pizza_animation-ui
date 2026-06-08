import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import 'round_icon_button.dart';

class QuantityPriceBar extends StatelessWidget {
  const QuantityPriceBar({
    super.key,
    required this.quantity,
    required this.price,
    required this.onAdd,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int quantity;
  final double price;
  final VoidCallback onAdd;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RoundIconButton(icon: Icons.remove, size: 38, onPressed: onDecrement),
        const SizedBox(width: 14),
        Text(
          '$quantity',
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
        ),
        const SizedBox(width: 14),
        RoundIconButton(icon: Icons.add, size: 38, onPressed: onIncrement),
        const Spacer(),
        Text(
          '\$${price.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(width: 12),
        FilledButton(
          onPressed: onAdd,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
            minimumSize: const Size(60, 44),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          ),
          child: const Text(
            'Add',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}
