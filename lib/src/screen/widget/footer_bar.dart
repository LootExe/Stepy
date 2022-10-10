import 'package:flutter/material.dart';

import 'elevated_container.dart';

class FooterBar extends StatelessWidget {
  const FooterBar({
    super.key,
    required this.distance,
    required this.calories,
    required this.avgSteps,
  });

  final double distance;
  final int calories;
  final int avgSteps;

  @override
  Widget build(BuildContext context) {
    return ElevatedContainer(
      height: 100.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [const Text('Distance'), Text('$distance km')],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [const Text('Calories'), Text('$calories kcal')],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [const Text('Average'), Text('$avgSteps Steps')],
          ),
        ],
      ),
    );
  }
}
