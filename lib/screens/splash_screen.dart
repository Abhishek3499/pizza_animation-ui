import 'package:flutter/material.dart';

import '../core/app_assets.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  Future<void> startAnimation() async {
    for (var i = 0; i < AppAssets.pizzaFrames.length; i++) {
      await Future.delayed(const Duration(milliseconds: 95));

      if (!mounted) return;

      setState(() {
        currentIndex = i;
      });
    }

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 260,
          height: 260,
          child: Stack(
            alignment: Alignment.center,
            children: List.generate(AppAssets.pizzaFrames.length, (index) {
              final isVisible = index <= currentIndex;

              return AnimatedPositioned(
                duration: const Duration(milliseconds: 70),
                curve: Curves.easeOutCubic,
                top: isVisible ? 0 : 20,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 70),
                  curve: Curves.easeOutExpo,
                  scale: isVisible ? 1 : 0.92,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 70),
                    curve: Curves.easeOut,
                    opacity: isVisible ? 1 : 0,
                    child: Image.asset(
                      AppAssets.pizzaFrames[index],
                      width: 240,
                      gaplessPlayback: true,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
