import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flutter/material.dart';

class AppDropdown<T> extends StatelessWidget {
  final String label;
  final String? hint;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabelBuilder;
  final void Function(T?) onChanged;
  final bool isLoading;
  final String? error;

  const AppDropdown({
    super.key,
    required this.label,
    this.hint,
    this.value,
    required this.items,
    required this.itemLabelBuilder,
    required this.onChanged,
    this.isLoading = false,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppStyles.regular12Inter.copyWith(color: AppColors.grey),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.black, width: 1),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.black, width: 1),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        errorText: error,
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: Center(
                child: SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.purple30,
                    ),
                  ),
                ),
              ),
            )
          : DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: value,
                isDense: true,
                isExpanded: true,
                hint: hint != null
                    ? Text(
                        hint!,
                        style: AppStyles.regular14Inter.copyWith(
                          color: AppColors.black10,
                        ),
                      )
                    : null,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.black,
                ),
                style: AppStyles.regular14Inter.copyWith(
                  color: AppColors.black,
                ),
                onChanged: onChanged,
                items: items.map((T item) {
                  return DropdownMenuItem<T>(
                    value: item,
                    child: Text(itemLabelBuilder(item)),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
