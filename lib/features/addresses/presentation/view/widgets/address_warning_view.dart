import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/ui/widgets/app_button.dart';
import 'package:flutter/material.dart';

class AddressWarningView extends StatelessWidget {
  final IconData mainIcon;
  final String title;
  final String description;
  final String mainButtonTitle;
  final void Function() mainButtonAction;

  const AddressWarningView(
    this.mainIcon,
    this.title,
    this.description,
    this.mainButtonTitle,
    this.mainButtonAction, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(flex: 2),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.lightPink,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Icon(mainIcon, size: 40, color: AppColors.purple70),
                  ),
                ),
                const SizedBox(height: 40),
                Text(title, style: AppStyles.bold20Inter),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    description,
                    style: AppStyles.regular14InterGreyHeight15,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 56),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: AppButton(
                    text: mainButtonTitle,
                    onPressed: mainButtonAction,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
