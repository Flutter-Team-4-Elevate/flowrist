import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/features/checkout/presentation/view/widgets/gift_text_field.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_cubit.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_event.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GiftMethods extends StatefulWidget {
  const GiftMethods({
    super.key,
    required this.onChanged,
  });

  final void Function({
    required bool isGift,
    required String name,
    required String phone,
  }) onChanged;

  @override
  State<GiftMethods> createState() => _GiftMethodsState();
}

class _GiftMethodsState extends State<GiftMethods> {
  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _phoneController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _notifyChanged({
    required bool isGift,
  }) {
    widget.onChanged(
      isGift: isGift,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
    );
  }

  void _clearGiftFields() {
    if (_nameController.text.isNotEmpty ||
        _phoneController.text.isNotEmpty) {
      _nameController.clear();
      _phoneController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<CheckoutCubit, CheckoutState>(
      buildWhen: (previous, current) =>
          previous.selectedPaymentMethod !=
              current.selectedPaymentMethod ||
          previous.isGift != current.isGift,
      builder: (context, state) {
        final isCashOnDelivery =
            state.selectedPaymentMethod == Endpoints.cash;

        final isGift = state.isGift;

        // Safety check:
        // Cash on Delivery should never display gift information.
        if (isCashOnDelivery && isGift) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;

            context.read<CheckoutCubit>().doEvent(
                UpdateGiftInfo(
                isGift: false,
                name: '',
                phone: '',
              ),
            );

            _clearGiftFields();
          });
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Row(
                children: [
                  Switch(
                    inactiveTrackColor: AppColors.purple20,
                    activeTrackColor: AppColors.purpleBase,
                    thumbColor: const WidgetStatePropertyAll(
                      AppColors.white,
                    ),
                    value: isGift,

                    // Disable gift when Cash on Delivery is selected.
                    onChanged: isCashOnDelivery
                        ? null
                        : (value) {
                            if (!value) {
                              _clearGiftFields();
                            }

                            _notifyChanged(
                              isGift: value,
                            );
                          },
                  ),

                  const SizedBox(width: 8),

                  Text(
                    localizations.itIsAGift,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: isCashOnDelivery
                          ? Colors.grey
                          : null,
                    ),
                  ),
                ],
              ),

              if (isGift && !isCashOnDelivery) ...[
                const SizedBox(height: 16),

                GiftTextField(
                  controller: _nameController,
                  hint: localizations.enterTheName,
                  label: localizations.name,
                  onChanged: (_) {
                    _notifyChanged(
                      isGift: true,
                    );
                  },
                ),

                const SizedBox(height: 16),

                GiftTextField(
                  controller: _phoneController,
                  hint: localizations.enterThePhoneNumber,
                  label: localizations.phoneNumber,
                  onChanged: (_) {
                    _notifyChanged(
                      isGift: true,
                    );
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}