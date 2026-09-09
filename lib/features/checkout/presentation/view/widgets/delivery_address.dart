import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/features/checkout/presentation/view/widgets/delivery_address_item.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_cubit.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_router.dart';
import '../../../../../core/constants/app_styles.dart';
import '../../../../../core/ui/widgets/app_button.dart';
import '../../view_model/checkout_event.dart';

class DeliveryAddress extends StatelessWidget {
  const DeliveryAddress({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        final addressesState = state.addressesState;

        if (addressesState.isLoading && addressesState.data == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.purpleBase),
          );
        }

        if (addressesState.errorMessage != null &&
            (addressesState.data == null || addressesState.data!.isEmpty)) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    addressesState.errorMessage!,
                    textAlign: TextAlign.center,
                    style: AppStyles.regular14Inter,
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    text: localizations.retry,
                    onPressed: () {
                      context.read<CheckoutCubit>().doEvent(
                        GetAddressesEvent(),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }

        final addresses = addressesState.data ?? const [];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.deliveryAddress,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              RadioGroup<String>(
                groupValue: state.selectedAddressId,
                onChanged: (value) {
                  if (value != null) {
                    context.read<CheckoutCubit>().doEvent(
                      SelectDeliveryAddressEvent(value),
                    );
                  }
                },
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: addresses.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return DeliveryAddressItem(addressEntity: addresses[index]);
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => context.push(AppRoutes.addAddress),
                  style: TextButton.styleFrom(side: BorderSide()),
                  icon: Icon(Icons.add, size: 24, color: AppColors.purpleBase),
                  label: Text(
                    localizations.addNew,
                    style: TextStyle(
                      color: AppColors.purpleBase,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
