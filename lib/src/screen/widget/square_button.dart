import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  const SquareButton({
    super.key,
    this.onPressed,
    this.fixedSize = const Size(48.0, 48.0),
    required this.child,
  });

  final VoidCallback? onPressed;
  final Size fixedSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(0.0),
        minimumSize: const Size(48.0, 48.0),
        fixedSize: fixedSize,
        // elevation: 4.0,
        //shadowColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: child,
    );
  }
}
