import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/features/home/search_and_filtering/search/presentation/cubit/search_cubit.dart';
import 'package:flowrist/features/home/search_and_filtering/search/presentation/cubit/search_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchInputField extends StatelessWidget {
  final TextEditingController controller;

  const SearchInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Container(
      height: screenHeight * 0.058,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.whiteBase,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.white70, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.white70, size: 24),
          const SizedBox(width: 8),
          Expanded(child: _buildTextField(context, l10n.search)),
          _buildClearButton(context),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String hint) {
    return TextField(
      controller: controller,
      autofocus: true,
      textInputAction: TextInputAction.search,
      style: AppStyles.regular14Inter,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppStyles.regular14Roboto,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
      onChanged: (value) {
        context.read<SearchCubit>().doEvent(SearchQueryChangedEvent(value));
      },
    );
  }

  Widget _buildClearButton(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        if (value.text.isEmpty) return const SizedBox.shrink();
        return GestureDetector(
          onTap: () {
            controller.clear();
            context.read<SearchCubit>().doEvent(const ClearSearchEvent());
          },
          child: const Icon(
            Icons.cancel_outlined,
            color: AppColors.white70,
            size: 20,
          ),
        );
      },
    );
  }
}
