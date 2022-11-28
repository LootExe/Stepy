import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/src/extensions.dart';

class StepProgressBar extends StatelessWidget {
  const StepProgressBar({
    super.key,
    required this.currentSteps,
    required this.stepsGoal,
    this.stepsRecord = 0,
    this.averageSteps = 0,
    this.strokeWidth = 2.0,
    this.stepFontSize = 64.0,
    this.progressColor,
    this.backgroundColor,
    this.bottomText,
  });

  final int currentSteps;
  final int stepsGoal;
  final int stepsRecord;
  final int averageSteps;

  final double strokeWidth;
  final double stepFontSize;

  final Color? progressColor;
  final Color? backgroundColor;

  final Text? bottomText;

  Color _getProgressColor(BuildContext context) {
    return progressColor ??
        ProgressIndicatorTheme.of(context).color ??
        Theme.of(context).colorScheme.primary;
  }

  Color _getBackgroundColor(BuildContext context) {
    return backgroundColor ??
        ProgressIndicatorTheme.of(context).circularTrackColor ??
        Theme.of(context).colorScheme.background;
  }

  double _getProgressBarPosition(int steps, int goal) =>
      (steps / goal).clamp(0.0, 1.0);

  String _parseDateToString(DateTime date) {
    final digit = date.day % 10;
    var suffix = 'th';

    if ((digit > 0 && digit < 4) && (date.day < 11 || date.day > 13)) {
      suffix = ['st', 'nd', 'rd'][digit - 1];
    }

    return DateFormat("EEEE, d'$suffix' MMM").format(date);
  }

  @override
  Widget build(BuildContext context) {
    final colorForeground = _getProgressColor(context);
    final colorBackground = _getBackgroundColor(context);

    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: _CircularPainter(
              maxValue: stepsGoal,
              bubbles: [
                TextBubble(
                  label: 'Goal',
                  value: stepsGoal,
                  color: colorForeground,
                  showMarker: false,
                ),
                TextBubble(
                  label: 'Record',
                  value: stepsRecord,
                  color: colorBackground,
                  showMarker: true,
                ),
                TextBubble(
                  label: 'Average',
                  value: averageSteps,
                  color: colorBackground,
                  showMarker: true,
                ),
              ],
              defaultTextStyle: DefaultTextStyle.of(context).style,
              color: colorBackground,
              strokeWidth: strokeWidth,
              radiusOffset: 0.0,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(26.0),
            child: CircularProgressIndicator(
              value: _getProgressBarPosition(currentSteps, stepsGoal),
              strokeWidth: strokeWidth,
              color: colorForeground,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentSteps.toString(),
                  style: TextStyle(
                    color: colorForeground,
                    fontSize: stepFontSize,
                  ),
                ),
                Divider(
                  indent: 125.0,
                  endIndent: 125.0,
                  color: colorBackground,
                  thickness: 0.75,
                ),
                const SizedBox(height: 12.0),
                Text(
                  _parseDateToString(DateTime.now()),
                  style: TextStyle(color: colorBackground),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TextBubble {
  const TextBubble({
    required this.label,
    required this.value,
    required this.color,
    required this.showMarker,
  });

  final String label;
  final int value;
  final Color color;
  final bool showMarker;
}

class _CircularPainter extends CustomPainter {
  _CircularPainter({
    required this.maxValue,
    required this.bubbles,
    required this.defaultTextStyle,
    required this.color,
    required this.strokeWidth,
    required this.radiusOffset,
  });

  final int maxValue;
  final List<TextBubble> bubbles;
  final TextStyle defaultTextStyle;

  final Color color;
  final double strokeWidth;
  final double radiusOffset;

  static const double _twoPi = math.pi * 2.0;
  static const double _circleOffset = 32.0;

  @override
  void paint(Canvas canvas, Size size) {
    // Move canvas origin into center
    canvas.translate(size.width / 2, size.height / 2);

    // Get the radius based on parent size
    double radius = math.min(size.width / 2, size.height / 2);
    radius -= _circleOffset - radiusOffset;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Draw circle
    canvas.drawCircle(Offset.zero, radius, paint);

    // Draw text bubbles
    for (var bubble in bubbles) {
      if (bubble.value > 0) {
        _drawText(
          canvas: canvas,
          size: size,
          bubble: bubble,
          maxValue: maxValue,
        );
      }
    }
  }

  void _drawText({
    required Canvas canvas,
    required Size size,
    required TextBubble bubble,
    required int maxValue,
  }) {
    const fontSize = 10.0;

    final textPainter = TextPainter(
      text: TextSpan(
        text: '${bubble.label}\n',
        children: [
          TextSpan(
            text: '${bubble.value}',
            style: defaultTextStyle.copyWith(
              color: bubble.color,
              fontSize: fontSize + 4.0,
            ),
          ),
        ],
        style: defaultTextStyle.copyWith(
          color: bubble.color,
          fontSize: fontSize,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: ui.TextDirection.ltr,
    )..layout(
        minWidth: 0,
        maxWidth: size.width,
      );

    double radius = math.min(size.width / 2, size.height / 2);
    radius -= _circleOffset - radiusOffset;

    // Get an text field offset based on the position around the circle
    // left and right, the bubble is further away from the circle than
    // top and bottom
    final normalizedValue = bubble.value.remap(0, maxValue, 0.0, 1.0);
    final sin = math.sin(_twoPi * normalizedValue).abs();
    final angleOffset =
        lerp(textPainter.size.height / 2, textPainter.size.width / 2, sin);

    final textRadius = radius + 20.0 + angleOffset;
    final textAngle = -math.pi / 2 + normalizedValue.remap(0, 1, 0, _twoPi);
    final textCenter = -textPainter.size.center(Offset.zero);

    final textPosition =
        _radiansToCoordinates(textCenter, textAngle, textRadius);

    textPainter.paint(canvas, textPosition);

    // Draw line to text
    if (bubble.showMarker) {
      final p1 = _radiansToCoordinates(Offset.zero, textAngle, radius + 10.0);
      final p2 = _radiansToCoordinates(Offset.zero, textAngle, radius);

      final paint = Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke;

      canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  bool shouldRepaint(_CircularPainter oldPainter) {
    return oldPainter.maxValue != maxValue ||
        oldPainter.bubbles != bubbles ||
        oldPainter.color != color ||
        oldPainter.strokeWidth != strokeWidth ||
        oldPainter.radiusOffset != radiusOffset;
  }

  Offset _radiansToCoordinates(Offset center, double radians, double radius) {
    var dx = center.dx + radius * math.cos(radians);
    var dy = center.dy + radius * math.sin(radians);
    return Offset(dx, dy);
  }

  double lerp(double a, double b, double t) {
    if (a == b || (a.isNaN == true) && (b.isNaN == true)) {
      return a;
    }

    return a * (1.0 - t) + b * t;
  }
}
