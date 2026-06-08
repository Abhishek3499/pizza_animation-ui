import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_colors.dart';
import '../widgets/curved_home_background.dart';
import '../widgets/pizza_showcase.dart';
import '../widgets/product_header.dart';
import '../widgets/quantity_price_bar.dart';
import '../widgets/size_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var quantity = 1;
  var selectedSize = 'M';
  var isFavorite = false;

  double get unitPrice {
    return switch (selectedSize) {
      'S' => 14.99,
      'L' => 21.99,
      _ => 17.99,
    };
  }

  void _changeQuantity(int delta) {
    setState(() {
      quantity = (quantity + delta).clamp(1, 9);
    });
  }

  void _showAddedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$quantity $selectedSize Pepperoni Blast added'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.pageBackground,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: CurvedHomeBackground(
              child: _HomeContent(
                isFavorite: isFavorite,
                quantity: quantity,
                selectedSize: selectedSize,
                totalPrice: unitPrice * quantity,
                onAdd: _showAddedMessage,
                onBackPressed: () {},
                onDecrement: () => _changeQuantity(-1),
                onFavoritePressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
                onIncrement: () => _changeQuantity(1),
                onSizeChanged: (value) {
                  setState(() {
                    selectedSize = value;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.isFavorite,
    required this.onAdd,
    required this.onBackPressed,
    required this.onDecrement,
    required this.onFavoritePressed,
    required this.onIncrement,
    required this.onSizeChanged,
    required this.quantity,
    required this.selectedSize,
    required this.totalPrice,
  });

  final bool isFavorite;
  final int quantity;
  final String selectedSize;
  final double totalPrice;
  final VoidCallback onAdd;
  final VoidCallback onBackPressed;
  final VoidCallback onDecrement;
  final VoidCallback onFavoritePressed;
  final VoidCallback onIncrement;
  final ValueChanged<String> onSizeChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 28, 0, 28),
      child: Column(
        children: [
          ProductHeader(
            isFavorite: isFavorite,
            onBackPressed: onBackPressed,
            onFavoritePressed: onFavoritePressed,
          ),
          const SizedBox(height: 18),
          Expanded(child: PizzaShowcase(selectedSize: selectedSize)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                SizeSelector(
                  selectedSize: selectedSize,
                  onSizeChanged: onSizeChanged,
                ),
                const SizedBox(height: 18),
                const _ProductDescription(),
                const SizedBox(height: 28),
                QuantityPriceBar(
                  quantity: quantity,
                  price: totalPrice,
                  onAdd: onAdd,
                  onDecrement: onDecrement,
                  onIncrement: onIncrement,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductDescription extends StatelessWidget {
  const _ProductDescription();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'The combination of perfectly melted mozzarella cheese, tangy tomato sauce, and a crispy yet chewy crust creates a harmonious balance that leaves you wanting more.',
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 12,
        height: 1.72,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
