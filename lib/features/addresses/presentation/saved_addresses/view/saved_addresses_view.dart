import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/ui/widgets/app_button.dart';
import 'package:flowrist/features/addresses/presentation/saved_addresses/view/widgets/saved_address_item_card.dart';
import 'package:flowrist/features/addresses/presentation/saved_addresses/view_model/saved_addresses_event.dart';
import 'package:flowrist/features/addresses/presentation/saved_addresses/view_model/saved_addresses_state.dart';
import 'package:flowrist/features/addresses/presentation/saved_addresses/view_model/saved_addresses_view_model.dart';
import 'package:flowrist/shared/addresses/domain/entities/address_entity.dart';
import 'package:flowrist/shared/addresses/presentation/widgets/address_bottom_sheet/empty_address_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SavedAddressesView extends StatefulWidget {
  const SavedAddressesView({super.key});

  @override
  State<SavedAddressesView> createState() => _SavedAddressesViewState();
}

class _SavedAddressesViewState extends State<SavedAddressesView> {
  @override
  void initState() {
    super.initState();
    context.read<SavedAddressesViewModel>().doEvent(GetSavedAddressesEvent());
  }

  Future<void> _navigateToAddAddress() async {
    final result = await context.push(AppRoutes.addAddress);
    if ((result == true || mounted) && mounted) {
      context.read<SavedAddressesViewModel>().doEvent(GetSavedAddressesEvent());
    }
  }

  Future<void> _navigateToEditAddress(AddressEntity address) async {
    final result = await context.push(AppRoutes.addAddress, extra: address);
    if ((result == true || mounted) && mounted) {
      context.read<SavedAddressesViewModel>().doEvent(GetSavedAddressesEvent());
    }
  }

  void _showDeleteConfirmationDialog(String addressId) {
    showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Address'),
          content: const Text(
            'Are you sure you want to delete this address?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(
                'Delete',
                style: TextStyle(color: AppColors.red),
              ),
            ),
          ],
        );
      },
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        context
            .read<SavedAddressesViewModel>()
            .doEvent(DeleteAddressEvent(addressId));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocListener<SavedAddressesViewModel, SavedAddressesState>(
      listenWhen: (previous, current) =>
      previous.deleteAddressState != current.deleteAddressState,
      listener: (context, state) {
        final deleteState = state.deleteAddressState;
        if (deleteState.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(deleteState.errorMessage!),
              backgroundColor: AppColors.red,
            ),
          );
        } else if (deleteState.data != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(deleteState.data!),
              backgroundColor: AppColors.green,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            onPressed: () {
              if (mounted && context.canPop()) {
                context.pop();
              }
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: AppColors.blackBase,
            ),
          ),
          titleSpacing: 0,
          title: Text(localizations.savedAddress, style: AppStyles.bold20Inter),
        ),
        body: BlocBuilder<SavedAddressesViewModel, SavedAddressesState>(
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
                          context.read<SavedAddressesViewModel>().doEvent(
                            GetSavedAddressesEvent(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }

            final addresses = addressesState.data ?? const [];

            if (addresses.isEmpty) {
              return RefreshIndicator(
                color: AppColors.purpleBase,
                onRefresh: () async {
                  context.read<SavedAddressesViewModel>().doEvent(
                    GetSavedAddressesEvent(),
                  );
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const SizedBox(height: 60),
                    const EmptyAddressView(),
                    const SizedBox(height: 32),
                    AppButton(
                      text: localizations.addNewaddress,
                      onPressed: _navigateToAddAddress,
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              color: AppColors.purpleBase,
              onRefresh: () async {
                context.read<SavedAddressesViewModel>().doEvent(
                  GetSavedAddressesEvent(),
                );
              },
              child: ListView(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                children: [
                  ...addresses.map(
                        (address) =>
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: SavedAddressItemCard(
                            address: address,
                            isDeleting: state.deletingAddressId == address.id,
                            onDelete: () =>
                                _showDeleteConfirmationDialog(address.id),
                            onEdit: () => _navigateToEditAddress(address),
                          ),
                        ),
                  ),
                  const SizedBox(height: 8),
                  AppButton(
                    text: localizations.addNewaddress,
                    onPressed: _navigateToAddAddress,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
