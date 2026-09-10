import 'dart:ui';
import 'package:flowrist/config/storage/secure_storage_service.dart';
import 'package:flowrist/core/constants/app_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppLanguageCubit extends Cubit<Locale> {
  final SecureStorageService _storage;

  AppLanguageCubit(this._storage) : super(const Locale('en')) {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final savedCode = await _storage.get(AppConstants.languageKey);
    if (savedCode == 'ar' || savedCode == 'en') {
      emit(Locale(savedCode));
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    if (state.languageCode == languageCode) return;
    await _storage.save(AppConstants.languageKey, languageCode);
    emit(Locale(languageCode));
  }
}
