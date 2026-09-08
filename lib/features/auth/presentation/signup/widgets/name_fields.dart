import 'package:flowrist/config/form_validator/form_validator.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/ui/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class NameFields extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final AppLocalizations localizations;
  final double screenWidth;

  const NameFields({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.localizations,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildFirstNameField()),
        SizedBox(width: screenWidth * 0.03),
        Expanded(child: _buildLastNameField()),
      ],
    );
  }

  Widget _buildFirstNameField() {
    return AppTextField(
      label: localizations.firstName,
      hint: localizations.enterFirstName,
      controller: firstNameController,
      validationPattern: FormValidator.namePattern,
      validationErrorMessage: localizations.generalValidationError,
      localizations: localizations,
    );
  }

  Widget _buildLastNameField() {
    return AppTextField(
      label: localizations.lastName,
      hint: localizations.enterLastName,
      controller: lastNameController,
      validationPattern: FormValidator.namePattern,
      validationErrorMessage: localizations.generalValidationError,
      localizations: localizations,
    );
  }
}
