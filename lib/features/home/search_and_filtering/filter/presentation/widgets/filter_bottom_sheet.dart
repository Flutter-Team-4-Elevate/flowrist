import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/features/home/search_and_filtering/filter/models/sort_option.dart';
import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final SortOption? currentSelection;

  const FilterBottomSheet({super.key, this.currentSelection});

  static Future<SortOption?> show(
    BuildContext context, {
    SortOption? currentSelection,
  }) {
    return showModalBottomSheet<SortOption?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          FilterBottomSheet(currentSelection: currentSelection),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late SortOption? _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.currentSelection;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.sizeOf(context);
    final localizations = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: mediaQuery.width * 0.05,
        vertical: mediaQuery.height * 0.02,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.white60,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: mediaQuery.height * 0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations.sortBy,
                style: AppStyles.medium18Inter.copyWith(
                  color: AppColors.purpleBase,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (_selectedOption != null)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedOption = null;
                    });
                  },
                  child: Text(
                    localizations.clear,
                    style: AppStyles.regular13.copyWith(
                      color: AppColors.purpleBase,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: mediaQuery.height * 0.01),
          ...SortOption.values.map(
            (option) => _buildOptionTile(option, context),
          ),
          SizedBox(height: mediaQuery.height * 0.025),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purpleBase,
                foregroundColor: AppColors.white,
                shape: const StadiumBorder(),
                elevation: 0,
              ),
              icon: const Icon(Icons.tune, size: 20),
              label: Text(localizations.filter, style: AppStyles.medium16Inter),
              onPressed: () => Navigator.of(context).pop(_selectedOption),
            ),
          ),
          SizedBox(height: mediaQuery.height * 0.015),
        ],
      ),
    );
  }

  Widget _buildOptionTile(SortOption option, BuildContext context) {
    final isSelected = _selectedOption == option;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedOption = isSelected ? null : option;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.purpleBase : AppColors.white50,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              option.getTitle(context),
              style: isSelected
                  ? AppStyles.regular14InterW500
                  : AppStyles.regular14Inter.copyWith(
                      color: AppColors.blackBase,
                    ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.purpleBase : AppColors.white70,
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.all(3),
              child: isSelected
                  ? Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.purpleBase,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
