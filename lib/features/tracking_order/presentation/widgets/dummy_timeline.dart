import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flutter/material.dart';

class OrderStatusItem extends StatelessWidget {
  final String title;
  final String date;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLast;

  const OrderStatusItem({
    super.key,
    required this.title,
    required this.date,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = isCompleted || isCurrent;

    return SizedBox(
      height: 75,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive ? Colors.pink : Colors.grey,
                    width: 2,
                  ),
                ),
                child: isActive
                    ? Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.pink,
                          ),
                        ),
                      )
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1,
                    color: isCompleted ? Colors.pink : Colors.grey,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppStyles.regular14Inter),
              if (date.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(date, style: AppStyles.regular13),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
