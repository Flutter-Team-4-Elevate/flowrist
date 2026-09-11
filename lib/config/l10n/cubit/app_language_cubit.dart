import 'dart:ui';
import 'package:flowrist/config/storage/secure_storage_service.dart';
import 'package:flowrist/core/constants/app_constants.dart';
import 'package:flowrist/core/constants/app_language.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppLanguageCubit extends Cubit<Locale> {
  final SecureStorageService _storage;

  AppLanguageCubit(this._storage) : super(AppLanguage.english.locale) {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final savedCode = await _storage.get(AppConstants.languageKey);
    final language = AppLanguage.fromCode(savedCode);
    if (language != null) {
      emit(language.locale);
    }
  }

  Future<void> changeLanguage(AppLanguage language) async {
    if (state.languageCode == language.code) return;
    await _storage.save(AppConstants.languageKey, language.code);
    emit(language.locale);
  }
}