import 'package:flutter/material.dart';

class RotateDropdownButtonIcon extends StatefulWidget {
  final bool isOpen;
  const RotateDropdownButtonIcon({super.key, required this.isOpen});

  @override
  State<RotateDropdownButtonIcon> createState() =>
      _RotateDropdownButtonIconState();
}

class _RotateDropdownButtonIconState extends State<RotateDropdownButtonIcon> {
  double turns = 0.0;

  @override
  Widget build(BuildContext context) {
    if (widget.isOpen) {
      turns = turns != 0.0 ? turns - 1 / 2 : turns;
    } else {
      turns = turns == 0.0 ? turns + 1 / 2 : turns;
    }

    return AnimatedRotation(
        turns: turns,
        duration: Duration(milliseconds: 500),
        child: Icon(Icons.arrow_downward_sharp));
  }
}
