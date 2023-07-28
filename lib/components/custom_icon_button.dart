import 'package:flutter/material.dart';
import 'package:tirkeme10/constands/app_colors.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
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
        color: AppColors.white,
        size: 60,
      ),
    );
  }
}
