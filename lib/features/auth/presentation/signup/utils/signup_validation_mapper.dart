import 'package:flowrist/config/form_validator/form_validator.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';

extension PasswordValidationResultMapper on PasswordValidationResult {
  String? toLocalizedMessage(AppLocalizations l10n) {
    return switch (this) {
      Valid() => null,
      LengthError() => l10n.passwordLengthError,
      UppercaseError() => l10n.passwordUppercaseError,
      LowercaseError() => l10n.passwordLowercaseError,
      NumberError() => l10n.passwordNumberError,
      SpecialCharError() => l10n.passwordSpecialCharError,
    };
  }
}
