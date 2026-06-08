import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/app_assets.dart';

class SizeSelector extends StatefulWidget {
  const SizeSelector({
    super.key,
    required this.selectedSize,
    required this.onSizeChanged,
  });

  final String selectedSize;
  final ValueChanged<String> onSizeChanged;

  @override
  State<SizeSelector> createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  static const _sideCenter = 65.0;

  var _isDragging = false;
  double? _dragCenter;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final sliceCenter = _isDragging
            ? _dragCenter ?? _centerForSize(widget.selectedSize, width)
            : _centerForSize(widget.selectedSize, width);

        return SizedBox(
          height: 76,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragStart: (details) {
              _updateDrag(details.localPosition.dx, width);
            },
            onHorizontalDragUpdate: (details) {
              _updateDrag(details.localPosition.dx, width);
            },
            onHorizontalDragEnd: (_) {
              setState(() {
                _isDragging = false;
                _dragCenter = null;
              });
            },
            onHorizontalDragCancel: () {
              setState(() {
                _isDragging = false;
                _dragCenter = null;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedPositioned(
                  duration: _isDragging
                      ? Duration.zero
                      : const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  top: 0,
                  left: sliceCenter - 46,
                  child: Column(
                    children: [
                      const _CurvedCaption(),
                      Transform.rotate(
                        angle: math.pi,
                        child: Image.asset(
                          AppAssets.pizzaFrames.first,
                          width: 92,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 46,
                  bottom: 8,
                  child: _SizeChip(
                    label: 'S',
                    isSelected: widget.selectedSize == 'S',
                    onTap: () => widget.onSizeChanged('S'),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: _SizeChip(
                    label: 'M',
                    isSelected: widget.selectedSize == 'M',
                    onTap: () => widget.onSizeChanged('M'),
                  ),
                ),
                Positioned(
                  right: 46,
                  bottom: 8,
                  child: _SizeChip(
                    label: 'L',
                    isSelected: widget.selectedSize == 'L',
                    onTap: () => widget.onSizeChanged('L'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateDrag(double position, double width) {
    final clampedPosition = position.clamp(_sideCenter, width - _sideCenter);
    final size = _sizeForPosition(clampedPosition, width);

    setState(() {
      _isDragging = true;
      _dragCenter = clampedPosition;
    });

    if (size != widget.selectedSize) {
      widget.onSizeChanged(size);
    }
  }

  double _centerForSize(String size, double width) {
    return switch (size) {
      'S' => _sideCenter,
      'L' => width - _sideCenter,
      _ => width / 2,
    };
  }

  String _sizeForPosition(double position, double width) {
    final centers = {
      'S': _sideCenter,
      'M': width / 2,
      'L': width - _sideCenter,
    };
    return centers.entries.reduce((closest, entry) {
      final closestDistance = (position - closest.value).abs();
      final entryDistance = (position - entry.value).abs();
      return entryDistance < closestDistance ? entry : closest;
    }).key;
  }
}

class _SizeChip extends StatelessWidget {
  const _SizeChip({
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? Colors.black : Colors.white,
      shape: const CircleBorder(),
      elevation: isSelected ? 2 : 7,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox.square(
          dimension: 38,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CurvedCaption extends StatelessWidget {
  const _CurvedCaption();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(82, 20), painter: _CurvedTextPainter());
  }
}

class _CurvedTextPainter extends CustomPainter {
  static const _text = 'D R A G  F O R  S I Z E';

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width * 0.48;
    final center = Offset(size.width / 2, size.height + 28);
    final startAngle = math.pi * 1.22;
    final sweep = math.pi * 0.56;
    final step = sweep / (_text.length - 1);

    for (var i = 0; i < _text.length; i++) {
      final angle = startAngle + step * i;
      final position = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );

      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.rotate(angle + math.pi / 2);

      final painter = TextPainter(
        text: TextSpan(
          text: _text[i],
          style: const TextStyle(
            color: Colors.black,
            fontSize: 5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      painter.paint(canvas, Offset(-painter.width / 2, -painter.height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _CurvedTextPainter oldDelegate) => false;
}
