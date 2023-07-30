// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:tirkeme10/constands/app_colors.dart';

class CustomIconsButton extends StatelessWidget {
  const CustomIconsButton({
    required this.icon,
    super.key,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        icon,
        color: Colors.amber,
        size: 60,
      ),
    );
  }
}
