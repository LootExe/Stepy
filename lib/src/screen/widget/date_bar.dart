import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'elevated_container.dart';

class DateBar extends StatelessWidget {
  const DateBar({super.key});

  final double _size = 60;

  Widget _buildDateField(DateTime date) {
    return ElevatedContainer(
      height: _size,
      width: _size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(DateFormat('E').format(date)),
          Text(date.day.toString()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildDateField(DateTime.now().subtract(const Duration(days: 4))),
        _buildDateField(DateTime.now().subtract(const Duration(days: 3))),
        _buildDateField(DateTime.now().subtract(const Duration(days: 2))),
        _buildDateField(DateTime.now().subtract(const Duration(days: 1))),
        _buildDateField(DateTime.now()),
      ],
    );
  }
}
