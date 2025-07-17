import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';

class ButtonCustom extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final TextStyle? style;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const ButtonCustom({
    super.key,
    required this.onPressed,
    this.label = "Custom Button",
    this.style,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.textPrimary,
            foregroundColor: foregroundColor ?? AppColors.colorWhite,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            label,
            style: style ??
                TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: foregroundColor ?? AppColors.colorWhite,
                ),
          ),
        ),
      ),
    );
  }
}
