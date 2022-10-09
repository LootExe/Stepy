import 'package:flutter/material.dart';

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
    return Container(
      margin: const EdgeInsets.only(bottom: 100.0),
      height: 100.0,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 3.0,
            spreadRadius: 1.5,
            offset: Offset(3.0, 3.0),
          ),
          BoxShadow(
            color: Colors.white12,
            blurRadius: 3.0,
            spreadRadius: 0.5,
            offset: Offset(-3.0, -3.0),
          )
        ],
      ),
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
