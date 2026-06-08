import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import 'round_icon_button.dart';

class ProductHeader extends StatelessWidget {
  const ProductHeader({
    super.key,
    required this.isFavorite,
    this.onBackPressed,
    this.onFavoritePressed,
  });

  final bool isFavorite;
  final VoidCallback? onBackPressed;
  final VoidCallback? onFavoritePressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          RoundIconButton(icon: Icons.arrow_back, onPressed: onBackPressed),
          const Spacer(),
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pizzas',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Pepperoni Blast',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const Spacer(),
          RoundIconButton(
            icon: isFavorite ? Icons.favorite : Icons.favorite_border,
            iconColor: isFavorite ? const Color(0xFFE84C2A) : Colors.black,
            onPressed: onFavoritePressed,
          ),
        ],
      ),
    );
  }
}
