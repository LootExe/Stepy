import 'dart:math' as math;

import 'package:flutter/material.dart';

class DotIcon extends StatelessWidget {
  const DotIcon({
    super.key,
    required this.borderColor,
    required this.dotColor,
  });

  final Color borderColor;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24.0,
      height: 24.0,
      child: CustomPaint(
        painter: _DotIconPainter(
          borderColor: borderColor,
          dotColor: dotColor,
        ),
      ),
    );
  }
}

class _DotIconPainter extends CustomPainter {
  const _DotIconPainter({
    required this.borderColor,
    required this.dotColor,
  });

  final Color borderColor;
  final Color dotColor;

  @override
  void paint(Canvas canvas, Size size) {
    // Move canvas origin into center
    canvas.translate(size.width / 2, size.height / 2);

    // Get the radius based on parent size
    double radius = math.min(size.width / 2, size.height / 2);

    // Draw circle
    canvas.drawCircle(
        Offset.zero,
        radius,
        Paint()
          ..color = borderColor
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke);

    // Draw center dot
    canvas.drawCircle(
        Offset.zero,
        radius - 10.0,
        Paint()
          ..color = dotColor
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(_DotIconPainter oldPainter) {
    return false;
  }
}
