import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/config/l10n/cubit/app_language_cubit.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_language.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/view/widgets/language_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeLanguageBottomSheet extends StatelessWidget {
  const ChangeLanguageBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => const ChangeLanguageBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLang = context.watch<AppLanguageCubit>().state.languageCode;
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.05,
        right: screenWidth * 0.05,
        top: 12,
        bottom: mediaQuery.padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: screenWidth * 0.12,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.white60,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.changeLanguage,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.purpleBase,
            ),
          ),
          const SizedBox(height: 16),
          ...AppLanguage.values.map(
            (language) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: LanguageCard(
                title: language == AppLanguage.arabic
                    ? l10n.arabic
                    : l10n.english,
                isSelected: currentLang == language.code,
                onTap: () {
                  context.read<AppLanguageCubit>().changeLanguage(language);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
