import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/shared/addresses/domain/entities/address_entity.dart';
import 'package:flowrist/shared/addresses/presentation/view_model/addresses_event.dart';
import 'package:flowrist/shared/addresses/presentation/view_model/addresses_state.dart';
import 'package:flowrist/shared/addresses/presentation/view_model/addresses_view_model.dart';
import 'package:flowrist/shared/addresses/presentation/widgets/address_bottom_sheet/address_item.dart';
import 'package:flowrist/shared/addresses/presentation/widgets/address_bottom_sheet/empty_address_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddressBottomSheetContent extends StatefulWidget {
  const AddressBottomSheetContent({super.key});

  @override
  State<AddressBottomSheetContent> createState() =>
      _AddressBottomSheetContentState();
}

class _AddressBottomSheetContentState extends State<AddressBottomSheetContent> {
  AddressEntity? _getSelectedAddress(AddressesState state) {
    final addresses = state.addressesState.data ?? [];
    final selectedId = state.selectedAddress?.id;

    if (selectedId == null) {
      return null;
    }

    for (final address in addresses) {
      if (address.id == selectedId) {
        return address;
      }
    }

    return null;
  }

  void _selectAddress(AddressEntity address) {
    context.read<AddressesViewModel>().selectAddress(address);
  }

  Future<void> _setAsDefault() async {
    final state = context.read<AddressesViewModel>().state;

    final selectedAddress = _getSelectedAddress(state);

    if (selectedAddress == null) {
      return;
    }

    await context.read<AddressesViewModel>().doEvent(
      SetDefaultAddress(selectedAddress.id),
    );

    if (!mounted) {
      return;
    }

    // Check if setting default succeeded
    final currentState = context.read<AddressesViewModel>().state;

    if (currentState.setDefaultAddressState.errorMessage == null) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressesViewModel, AddressesState>(
      buildWhen: (previous, current) {
        return previous.addressesState != current.addressesState ||
            previous.selectedAddress != current.selectedAddress ||
            previous.setDefaultAddressState != current.setDefaultAddressState;
      },
      builder: (context, state) {
        final addresses = state.addressesState.data ?? [];

        return AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.bottomCenter,
          child: _buildSheet(context, state, addresses),
        );
      },
    );
  }

  Widget _buildSheet(
    BuildContext context,
    AddressesState state,
    List<AddressEntity> addresses,
  ) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    final maxSheetHeight = (screenHeight * 0.80).clamp(300.0, 800.0);

    if (addresses.isEmpty) {
      return SafeArea(
        child: Material(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHandle(),

                const SizedBox(height: 20),

                Text(
                  AppLocalizations.of(context)!.selectAddress,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                // Empty view
                const EmptyAddressView(),

                const SizedBox(height: 16),

                _buildAddAddressButton(),
              ],
            ),
          ),
        ),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxSheetHeight),
      child: SafeArea(
        child: Material(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHandle(),

                const SizedBox(height: 20),

                Text(
                  AppLocalizations.of(context)!.selectAddress,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                // Address list
                Flexible(child: _buildAddressList(state)),

                const SizedBox(height: 16),

                _buildAddressActions(state),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.white70,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildAddressList(AddressesState state) {
    final addresses = state.addressesState.data ?? [];

    if (addresses.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = MediaQuery.sizeOf(context).height;

        const double itemHeight = 80;

        const double separatorHeight = 12;

        final visibleItemCount = addresses.length.clamp(1, 8);

        final desiredHeight =
            (visibleItemCount * itemHeight) +
            ((visibleItemCount - 1) * separatorHeight);

        final maxHeight = screenHeight * 0.60;

        final listHeight = desiredHeight.clamp(60.0, maxHeight);

        return SizedBox(
          height: listHeight,
          child: ListView.separated(
            itemCount: addresses.length,
            separatorBuilder: (_, _) {
              return const SizedBox(height: separatorHeight);
            },
            itemBuilder: (context, index) {
              final address = addresses[index];

              return AddressItem(
                address: address,
                isSelected: address.id == state.selectedAddress?.id,
                onTap: () {
                  _selectAddress(address);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAddressActions(AddressesState state) {
    final selectedAddress = _getSelectedAddress(state);

    final isLoading = state.setDefaultAddressState.isLoading;

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: ElevatedButton(
            onPressed: selectedAddress == null || isLoading
                ? null
                : _setAsDefault,
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(AppLocalizations.of(context)!.setAsDefault),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(child: _buildAddIconButton()),
      ],
    );
  }

  Widget _buildAddIconButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () async {
        final result = await context.push<bool>(AppRoutes.addAddress);

        if (!mounted) {
          return;
        }

        if (result == true) {
          await context.read<AddressesViewModel>().doEvent(RefreshAddresses());
        }
      },
      child: const Icon(Icons.add, size: 25),
    );
  }

  Widget _buildAddAddressButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          final result = await context.push<bool>(AppRoutes.addAddress);

          if (!mounted) {
            return;
          }

          if (result == true) {
            await context.read<AddressesViewModel>().doEvent(
              RefreshAddresses(),
            );
          }
        },
        icon: const Icon(Icons.add, size: 25),
        label: Text(AppLocalizations.of(context)!.addNewaddress),
      ),
    );
  }
}
