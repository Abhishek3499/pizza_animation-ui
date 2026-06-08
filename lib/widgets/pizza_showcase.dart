import 'package:flutter/material.dart';

import '../core/app_assets.dart';

class PizzaShowcase extends StatefulWidget {
  const PizzaShowcase({super.key, required this.selectedSize});

  final String selectedSize;

  @override
  State<PizzaShowcase> createState() => _PizzaShowcaseState();
}

class _PizzaShowcaseState extends State<PizzaShowcase> {
  static const _focusHandleSize = 22.0;
  static const _initialPage = 1000;

  late final PageController _pageController;
  var _currentPizzaIndex = 0;
  var _isZooming = false;
  Offset? _focus;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;
        final basePizzaSize = (height * 0.72).clamp(132.0, 210.0);
        final sizeMultiplier = switch (widget.selectedSize) {
          'S' => 0.78,
          'L' => 1.18,
          _ => 1.0,
        };
        final maxPizzaSize = (height * 0.96).clamp(142.0, 250.0);
        final pizzaSize = (basePizzaSize * sizeMultiplier).clamp(
          112.0,
          maxPizzaSize,
        );
        final sideSize = (pizzaSize * 0.44).clamp(64.0, 96.0);
        final pizzaTop = (height - pizzaSize) / 2;
        final sideTop = pizzaTop + pizzaSize * 0.32;
        final focus = _focus ?? Offset(pizzaSize / 2, pizzaSize / 2);
        final activePizza = AppAssets.showcasePizzas[_currentPizzaIndex];
        final previousPizza = AppAssets.showcasePizzas[_previousPizzaIndex];
        final nextPizza = AppAssets.showcasePizzas[_nextPizzaIndex];

        return SizedBox(
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned(
                left: -sideSize * 0.76,
                top: sideTop,
                child: _SidePizza(
                  asset: previousPizza,
                  size: sideSize,
                  rotation: -0.18,
                ),
              ),
              Positioned(
                right: -sideSize * 0.76,
                top: sideTop,
                child: _SidePizza(
                  asset: nextPizza,
                  size: sideSize,
                  rotation: 0.18,
                ),
              ),
              Positioned(
                top: pizzaTop,
                left: 0,
                right: 0,
                height: pizzaSize,
                child: PageView.builder(
                  controller: _pageController,
                  physics: _isZooming
                      ? const NeverScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
                  onPageChanged: (page) {
                    setState(() {
                      _currentPizzaIndex =
                          page % AppAssets.showcasePizzas.length;
                      _focus = null;
                      _isZooming = false;
                    });
                  },
                  itemBuilder: (context, page) {
                    final asset = AppAssets
                        .showcasePizzas[page % AppAssets.showcasePizzas.length];

                    return Center(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onLongPressStart: (details) {
                          setState(() {
                            _isZooming = true;
                            _focus = _clampFocus(
                              details.localPosition,
                              pizzaSize,
                            );
                          });
                        },
                        onLongPressMoveUpdate: (details) {
                          setState(() {
                            _focus = _clampFocus(
                              details.localPosition,
                              pizzaSize,
                            );
                          });
                        },
                        onLongPressEnd: (_) => _resetZoom(),
                        onLongPressCancel: _resetZoom,
                        child: _ZoomablePizzaImage(
                          focus: focus,
                          isZooming: _isZooming && asset == activePizza,
                          size: pizzaSize,
                          asset: asset,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: pizzaTop + focus.dy - _focusHandleSize / 2,
                left: (width - pizzaSize) / 2 + focus.dx - _focusHandleSize / 2,
                child: IgnorePointer(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 140),
                    opacity: 1,
                    child: Container(
                      width: _focusHandleSize,
                      height: _focusHandleSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.08),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int get _nextPizzaIndex {
    return (_currentPizzaIndex + 1) % AppAssets.showcasePizzas.length;
  }

  int get _previousPizzaIndex {
    return (_currentPizzaIndex - 1 + AppAssets.showcasePizzas.length) %
        AppAssets.showcasePizzas.length;
  }

  Offset _clampFocus(Offset value, double size) {
    final radius = size / 2;
    final center = Offset(radius, radius);
    final allowedRadius = radius - _focusHandleSize / 2;
    final delta = value - center;

    if (delta.distance <= allowedRadius) {
      return value;
    }

    return center + Offset.fromDirection(delta.direction, allowedRadius);
  }

  void _resetZoom() {
    setState(() {
      _isZooming = false;
      _focus = null;
    });
  }
}

class _ZoomablePizzaImage extends StatelessWidget {
  const _ZoomablePizzaImage({
    required this.focus,
    required this.isZooming,
    required this.size,
    required this.asset,
  });

  final String asset;
  final Offset focus;
  final bool isZooming;
  final double size;

  @override
  Widget build(BuildContext context) {
    final center = Offset(size / 2, size / 2);
    final scale = isZooming ? 2.15 : 1.0;
    final translation = (center - focus) * (scale - 1);

    return AnimatedScale(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOutCubic,
      scale: isZooming ? 1.08 : 1,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isZooming ? 0.30 : 0.22),
              blurRadius: isZooming ? 24 : 18,
              offset: const Offset(0, 9),
            ),
          ],
        ),
        child: ClipOval(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOutCubic,
            color: Colors.transparent,
            child: Transform.translate(
              offset: translation,
              child: Transform.scale(
                scale: scale,
                child: Image.asset(
                  asset,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SidePizza extends StatelessWidget {
  const _SidePizza({
    required this.asset,
    required this.rotation,
    required this.size,
  });

  final String asset;
  final double rotation;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Image.asset(
        asset,
        width: size,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}
