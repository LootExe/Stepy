import 'package:flutter/material.dart';
import 'package:curved_progress_bar/curved_progress_bar.dart';
import 'package:intl/intl.dart';

class StepsIndicator extends StatelessWidget {
  StepsIndicator({
    super.key,
    required this.currentSteps,
    required this.stepsGoal,
  });

  final int currentSteps;
  final int stepsGoal;

  final _numberFormat = NumberFormat.decimalPattern('en_us');

  double _getProgressBarPosition(int steps, int goal) =>
      (steps / goal).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(50.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _numberFormat.format(currentSteps),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48.0,
                    ),
                  ),
                  const Text('Steps'),
                ],
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Text('Goal: ${_numberFormat.format(stepsGoal)}'),
              ),
            ),
            CurvedCircularProgressIndicator(
              value: _getProgressBarPosition(currentSteps, stepsGoal),
              strokeWidth: 16,
              animationDuration: const Duration(seconds: 1),
              // TODO: Define colors somewhere in ThemeManager
              backgroundColor: Color(0xFF393939),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
