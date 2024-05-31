import 'package:dosemate/utils/utils.dart';
import 'package:flutter/material.dart';

class DropdownItem extends StatelessWidget {
  final Widget icon;
  final String text;

  const DropdownItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        8.spaceX,
        Text(text),
      ],
    );
  }
}
