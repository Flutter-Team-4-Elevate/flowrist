import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/constants/flowery_icons.dart';
import 'package:flowrist/shared/addresses/domain/entities/address_entity.dart';
import 'package:flowrist/shared/addresses/presentation/view_model/addresses_event.dart';
import 'package:flowrist/shared/addresses/presentation/view_model/addresses_state.dart';
import 'package:flowrist/shared/addresses/presentation/view_model/addresses_view_model.dart';
import 'package:flowrist/shared/addresses/presentation/widgets/address_bottom_sheet/address_bottom_sheet_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryLocationHeader extends StatefulWidget {
  const DeliveryLocationHeader({super.key});

  @override
  State<DeliveryLocationHeader> createState() => _DeliveryLocationHeaderState();
}

class _DeliveryLocationHeaderState extends State<DeliveryLocationHeader> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAddress();
    });
  }

  Future<void> _initializeAddress() async {
    if (!mounted) return;

    await context.read<AddressesViewModel>().doEvent(InitializeAddress());
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<AddressesViewModel, AddressesState>(
      builder: (context, state) {
        final selectedAddress = state.selectedAddress;

        return Row(
          children: [
            const Icon(FloweryIcons.location, size: 20),

            const SizedBox(width: 2),

            Expanded(child: _buildLocationText(selectedAddress, localizations)),

            Transform.rotate(
              angle: 3.14 / 2,
              child: IconButton(
                onPressed:
                    state.addressesState.isLoading ||
                        state.addressesState.errorMessage != null
                    ? null
                    : () {
                        _showAddressBottomSheet(context);
                      },
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: AppColors.purpleBase,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLocationText(
    AddressEntity? address,
    AppLocalizations localizations,
  ) {
    if (address == null) {
      return Text(
        localizations.deliverTo,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppStyles.medium18Inter.copyWith(fontSize: 14),
      );
    }

    return Text(
      '${localizations.deliverTo} '
      '${address.area}-${address.addressLine}',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppStyles.medium18Inter.copyWith(fontSize: 14),
    );
  }

  Future<void> _showAddressBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      useRootNavigator: true,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<AddressesViewModel>(),
          child: const AddressBottomSheetContent(),
        );
      },
    );
  }
}
