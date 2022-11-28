import 'package:flutter/material.dart';

class StepGoalDialog {
  static Future<int> show({
    required BuildContext context,
    required int initialValue,
  }) async {
    final String? value = await showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(
          text: initialValue.toString(),
        );

        return AlertDialog(
          content: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            maxLength: 6,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Enter new goal',
              filled: false,
              suffixIcon: Icon(Icons.edit),
            ),
            onFieldSubmitted: (value) => Navigator.of(context).pop(value),
          ),
          actions: [
            TextButton(
              child: const Text('Set'),
              onPressed: () => Navigator.of(context).pop(controller.text),
            ),
          ],
        );
      },
    );

    if (value == null) {
      return initialValue;
    }

    final newGoal = int.tryParse(value);

    if (newGoal != null && !newGoal.isNegative && newGoal.isFinite) {
      return newGoal;
    } else {
      return initialValue;
    }
  }
}
