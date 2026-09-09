import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class GiftTextField extends StatelessWidget {
  const GiftTextField({
    super.key,
    required this.hint,
    required this.label,
    required this.controller,
    this.onChanged,
  });

  final String hint;
  final String label;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hint: Text(
          hint,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.white70,
          ),
        ),
        label: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.grey,
          ),
        ),
      ),
    );
  }
}