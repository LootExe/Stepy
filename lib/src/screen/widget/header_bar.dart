import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'square_button.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({
    super.key,
    required this.onButtonPressed,
    required this.date,
    required this.dateRange,
  });

  final VoidCallback onButtonPressed;
  final DateTime date;
  // TODO: Change to enum or class that presents (Daily, Weekly, Monthly, Yearly, All-Time)
  final String dateRange;

  String _parseDateToString(DateTime date) {
    final digit = date.day % 10;
    var suffix = 'th';

    if ((digit > 0 && digit < 4) && (date.day < 11 || date.day > 13)) {
      suffix = ['st', 'nd', 'rd'][digit - 1];
    }

    return DateFormat("EEEE, d'$suffix' MMMM, y").format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SquareButton(
          onPressed: onButtonPressed,
          child: const Icon(Icons.menu, size: 36.0),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _parseDateToString(date),
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
                Text(
                  dateRange,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
