import 'package:flutter/material.dart';

class ElevatedContainer extends StatelessWidget {
  const ElevatedContainer({
    super.key,
    this.height = 100,
    this.width,
    required this.child,
  });

  final double height;
  final double? width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
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
      child: child,
    );
  }
}
