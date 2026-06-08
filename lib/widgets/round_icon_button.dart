import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconColor = Colors.black,
    this.size = 46,
  });

  final IconData icon;
  final Color iconColor;
  final VoidCallback? onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 7,
        shadowColor: Colors.black.withValues(alpha: 0.12),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Icon(icon, size: 22, color: iconColor),
        ),
      ),
    );
  }
}
