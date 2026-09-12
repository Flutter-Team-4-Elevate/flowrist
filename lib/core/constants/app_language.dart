import 'dart:ui';

enum AppLanguage {
  arabic('ar'),
  english('en');

  final String code;
  const AppLanguage(this.code);

  Locale get locale => Locale(code);

  static AppLanguage? fromCode(String? code) {
    for (final language in AppLanguage.values) {
      if (language.code == code) return language;
    }
    return null;
  }
}
