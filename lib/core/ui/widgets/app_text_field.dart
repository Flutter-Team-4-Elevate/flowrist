import 'package:flowrist/config/form_validator/form_validator.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextStyle labelStyle;
  final TextStyle hintStyle;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? validationPattern;
  final String? validationErrorMessage;
  final void Function(String)? onChange;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final AppLocalizations localizations;

  AppTextField({
    super.key,
    required this.label,
    required this.hint,
    TextStyle? labelStyle,
    TextStyle? hintStyle,
    this.controller,
    this.validator,
    this.validationPattern,
    this.validationErrorMessage,
    this.onChange,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    required this.localizations,
  }) : labelStyle = labelStyle ?? AppStyles.regular12Roboto,
       hintStyle = hintStyle ?? AppStyles.regular14Roboto {
    assert(
      !((validationPattern != null || validationErrorMessage != null) &&
          validator != null),
      "You can either provide a custom validator or provide the validation pattern and error.",
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.black, width: 1),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: labelStyle,
        labelText: label,
        hintText: hint,
        hintStyle: hintStyle,
        suffixIcon: suffixIcon,
        errorMaxLines: 3,
      ),
      controller: controller,
      validator: validator ?? defaultValidator,
      onChanged: onChange,
      obscureText: obscureText,
      keyboardType: keyboardType,
    );
  }

  String? defaultValidator(String? input) {
    if (input == null) {
      return localizations.generalValidationError;
    }

    if (input.isEmpty) {
      return localizations.emptyValidationError;
    }

    if (validationPattern != null &&
        !FormValidator.validate(validationPattern!, input)) {
      return validationErrorMessage;
    }

    return null;
  }
}
