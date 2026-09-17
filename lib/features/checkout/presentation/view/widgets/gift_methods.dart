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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

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
    _nameController.clear();
    _phoneController.clear();
  }

  void _disableGift(BuildContext context) {
    if (_nameController.text.isNotEmpty ||
        _phoneController.text.isNotEmpty) {
      _clearGiftFields();
    }

    context.read<CheckoutCubit>().doEvent(
          UpdateGiftInfo(
            isGift: false,
            name: '',
            phone: '',
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocListener<CheckoutCubit, CheckoutState>(
      listenWhen: (previous, current) =>
          previous.selectedPaymentMethod !=
          current.selectedPaymentMethod,
      listener: (context, state) {
        final isCashOnDelivery =
            state.selectedPaymentMethod == Endpoints.cash;

        if (isCashOnDelivery && state.isGift) {
          _disableGift(context);
        }

        if (isCashOnDelivery) {
          _clearGiftFields();
        }
      },
      child: BlocBuilder<CheckoutCubit, CheckoutState>(
        buildWhen: (previous, current) =>
            previous.selectedPaymentMethod !=
                current.selectedPaymentMethod ||
            previous.isGift != current.isGift,
        builder: (context, state) {
          final isCashOnDelivery =
              state.selectedPaymentMethod == Endpoints.cash;

          final isGift = state.isGift;

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
                      value: isCashOnDelivery ? false : isGift,

                      // Gift is not available for COD.
                      onChanged: isCashOnDelivery
                          ? null
                          : (value) {
                              if (!value) {
                                _clearGiftFields();
                              }

                              _notifyChanged(isGift: value);
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
                      _notifyChanged(isGift: true);
                    },
                  ),

                  const SizedBox(height: 16),

                  GiftTextField(
                    controller: _phoneController,
                    hint: localizations.enterThePhoneNumber,
                    label: localizations.phoneNumber,
                    onChanged: (_) {
                      _notifyChanged(isGift: true);
                    },
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
 
