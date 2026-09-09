import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PaymentMethodItem extends StatelessWidget {
  const PaymentMethodItem({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Opacity(
        opacity: onTap == null ? 0.6 : 1,
        child: Container(
          height: 60,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? AppColors.purpleBase
                  : AppColors.white90.withValues(
                      alpha: 0.45,
                    ),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              RadioGroup<bool>(
                groupValue: isSelected,
                onChanged: (_) {
                  onTap?.call();
                },
                child: const Radio<bool>(
                  value: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}