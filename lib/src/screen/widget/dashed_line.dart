import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class DashedLine extends StatelessWidget {
  const DashedLine({
    super.key,
    required this.dash,
    this.axis = Axis.horizontal,
  });

  final Dash dash;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashPainter(
        dash: dash,
        axis: axis,
      ),
    );
  }
}

class Dash {
  Dash({
    required this.dashSize,
    required this.gapSize,
    required this.paint,
  });

  final double dashSize;
  final double gapSize;
  final Paint paint;
}

class _DashPainter extends CustomPainter {
  _DashPainter({
    required this.dash,
    required this.axis,
  });

  final Dash dash;
  final Axis axis;

  static const double _vertical = 90 * math.pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    if (dash.dashSize <= 0 || dash.gapSize <= 0) {
      return;
    }

    double length = size.width;

    if (axis == Axis.vertical) {
      length = size.height;
      canvas.rotate(_vertical);
    }

    _drawDashedLine(canvas, length, dash);
  }

  @override
  bool shouldRepaint(covariant _DashPainter oldDelegate) {
    return oldDelegate.dash != dash || oldDelegate.axis != axis;
  }

  void _drawDashedLine(Canvas canvas, double length, Dash dash) {
    final dashSize = dash.dashSize;
    final gapSize = dash.gapSize;
    final paint = dash.paint;
    final strokeVerticalOverflow = paint.strokeWidth / 2;

    final List<Offset> points = [];

    if (paint.strokeCap == StrokeCap.butt) {
      final jointSize = dashSize + gapSize;
      final leapSize = (length + gapSize) % jointSize;
      double? firstDashSize;
      double position = 0.0;

      if (leapSize != 0) {
        if (gapSize > dashSize && gapSize - leapSize >= dashSize) {
          position = leapSize / 2;
        } else {
          firstDashSize = (dashSize - gapSize + leapSize) / 2;
        }
      }

      if (firstDashSize != null) {
        points.add(Offset(position, strokeVerticalOverflow));
        points.add(Offset(position += firstDashSize, strokeVerticalOverflow));
        position += gapSize;
      }

      do {
        points.add(Offset(position, strokeVerticalOverflow));
        points.add(Offset(position + dashSize, strokeVerticalOverflow));
      } while ((position += jointSize) + dashSize <= length);

      if (firstDashSize != null) {
        points.add(Offset(length - firstDashSize, strokeVerticalOverflow));
        points.add(Offset(length, strokeVerticalOverflow));
      }
    } else {
      final newDashSize = dashSize + paint.strokeWidth;
      final jointSize = newDashSize + gapSize;
      final leapSize = (length + gapSize) % jointSize;
      double position = leapSize / 2;

      do {
        points.add(Offset(position, strokeVerticalOverflow));
        points.add(Offset(position + dashSize, strokeVerticalOverflow));
      } while ((position += jointSize) + dashSize <= length);

      if (leapSize < paint.strokeWidth) {
        points.first = Offset(
          points.first.dx + strokeVerticalOverflow,
          points.first.dy,
        );
        points.last = Offset(
          points.last.dx - strokeVerticalOverflow,
          points.last.dy,
        );
      }
    }

    canvas.drawPoints(PointMode.lines, points, paint);
  }
}
