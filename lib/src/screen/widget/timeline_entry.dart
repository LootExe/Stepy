import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dot_icon.dart';

enum ContentSide { left, right }

class TimelineEntry extends StatelessWidget {
  const TimelineEntry({
    super.key,
    required this.date,
    required this.steps,
    required this.side,
  });

  final DateTime date;
  final int steps;
  final ContentSide side;

  Widget get _textChild => Expanded(
        child: Column(
          children: [
            Text(
              '$steps Steps',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                height: 1.2,
              ),
            ),
            Text(
              _parseDateToString(date),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
                height: 1.2,
              ),
            ),
          ],
        ),
      );

  static String _parseDateToString(DateTime date) {
    final digit = date.day % 10;
    var suffix = 'th';

    if ((digit > 0 && digit < 4) && (date.day < 11 || date.day > 13)) {
      suffix = ['st', 'nd', 'rd'][digit - 1];
    }

    return DateFormat("EEE, d'$suffix' MMM ''yy").format(date);
  }

  @override
  Widget build(BuildContext context) {
    final separatorIcon = DotIcon(
      borderColor: Colors.grey,
      dotColor: Theme.of(context).colorScheme.secondary,
    );

    List<Widget> children = [];

    if (side == ContentSide.left) {
      children.addAll([
        _textChild,
        separatorIcon,
        const Spacer(),
      ]);
    } else {
      children.addAll([
        const Spacer(),
        separatorIcon,
        _textChild,
      ]);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
