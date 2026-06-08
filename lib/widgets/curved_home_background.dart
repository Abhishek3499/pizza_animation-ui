import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class CurvedHomeBackground extends StatelessWidget {
  const CurvedHomeBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              const Positioned.fill(child: ColoredBox(color: Colors.white)),
              Positioned(
                top: 0,
                left: -10,
                right: -10,
                height: constraints.maxHeight * 0.60,
                child: ClipPath(
                  clipper: const _HomeCurveClipper(),
                  child: const ColoredBox(color: AppColors.homeTop),
                ),
              ),
              Positioned.fill(child: child),
            ],
          );
        },
      ),
    );
  }
}

class _HomeCurveClipper extends CustomClipper<Path> {
  const _HomeCurveClipper();

  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height * 0.82)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 1.16,
        size.width,
        size.height * 0.82,
      )
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant _HomeCurveClipper oldClipper) => false;
}
