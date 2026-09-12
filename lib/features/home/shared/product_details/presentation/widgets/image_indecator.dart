import 'package:flutter/material.dart';

class ImageIndicator extends StatelessWidget {
  final int currentIndex;
  final int count;

  const ImageIndicator({
    super.key,
    required this.currentIndex,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == currentIndex ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}
