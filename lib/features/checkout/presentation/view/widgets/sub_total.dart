import 'package:flutter/material.dart';

class SubTotal extends StatelessWidget {
  const SubTotal({
    super.key,
    required this.title,
    required this.price,
    this.textStyle,
  });
  final String title;
  final String price;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style:
              textStyle ??
              TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: .7),
              ),
        ),

        Text(
          price,
          style:
              textStyle ??
              TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: .7),
              ),
        ),
      ],
    );
  }
}
