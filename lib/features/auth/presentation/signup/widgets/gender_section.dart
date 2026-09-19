import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flutter/material.dart';

enum Gender {
  male(0),
  female(1);

  final int value;
  const Gender(this.value);
}

class GenderSection extends StatelessWidget {
  final Gender selectedGender;
  final ValueChanged<Gender> onGenderChanged;
  final AppLocalizations localizations;
  final double screenWidth;

  const GenderSection({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.localizations,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(localizations.gender, style: AppStyles.medium18Inter),
        SizedBox(width: screenWidth * 0.04),
        Expanded(child: _buildRadioGroup()),
      ],
    );
  }

  Widget _buildRadioGroup() {
    return RadioGroup<Gender>(
      groupValue: selectedGender,
      onChanged: (val) {
        if (val != null) onGenderChanged(val);
      },
      child: Row(
        children: [
          _buildRadioOption(localizations.female, Gender.female),
          SizedBox(width: screenWidth * 0.03),
          _buildRadioOption(localizations.male, Gender.male),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String title, Gender value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<Gender>(value: value, activeColor: AppColors.purpleBase),
        Text(title, style: AppStyles.regular14Inter),
      ],
    );
  }
}
