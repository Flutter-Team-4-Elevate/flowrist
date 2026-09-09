import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/features/addresses/presentation/view/widgets/add_address_form_view.dart';
import 'package:flowrist/features/addresses/presentation/view/widgets/address_warning_view.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_event.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_state.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_view_model.dart';
import 'package:flowrist/shared/addresses/domain/entities/address_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/permission_status_entity.dart';

class AddAddressView extends StatefulWidget {
  final AddressEntity? addressToEdit;

  const AddAddressView({super.key, this.addressToEdit});

  @override
  State<AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<AddAddressView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.addressToEdit != null) {
      context
          .read<AddAddressViewModel>()
          .doEvent(InitializeForEditEvent(widget.addressToEdit!));
    } else {
      context.read<AddAddressViewModel>().doEvent(CheckLocationPermission());
    }
    context.read<AddAddressViewModel>().doEvent(GetGovernoratesEvent());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<AddAddressViewModel>().doEvent(CheckLocationPermission());
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocListener<AddAddressViewModel, AddAddressState>(
      listenWhen: (previous, current) => previous.saveAddressState != current.saveAddressState,
      listener: (context, state) {
        final saveState = state.saveAddressState;

        // Still saving
        if (saveState.isLoading) {
          return;
        }

        // Save failed
        if (saveState.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(saveState.errorMessage!)));

          return;
        }
        if (saveState.data == true) {
          context.pop(true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              if (mounted && context.canPop()) {
                context.pop(false);
              }
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
          ),
          titleSpacing: 0,
          title: Text(localizations.address, style: AppStyles.bold20Inter),
        ),
        body: BlocBuilder<AddAddressViewModel, AddAddressState>(
          buildWhen: (previous, current) {
            return previous.locationPermission != current.locationPermission ||
                previous.locationEnabled != current.locationEnabled;
          },
          builder: (context, state) {
            if (widget.addressToEdit != null) {
              return AddAddressFormView(addressToEdit: widget.addressToEdit);
            }

            if (state.locationPermission.isLoading) {
              return _loadingView();
            }

            return _buildViewByPermissionStatus(
              permissionStatus:
                  state.locationPermission.data ??
                  PermissionStatusEntity.denied,
              isServiceEnabled: state.locationEnabled,
              localizations: localizations,
            );
          },
        ),
      ),
    );
  }

  Widget _loadingView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildViewByPermissionStatus({
    required PermissionStatusEntity permissionStatus,
    required bool isServiceEnabled,
    required AppLocalizations localizations,
  }) {
    switch (permissionStatus) {
      case PermissionStatusEntity.denied:
        return AddAddressFormView(
          showSoftPermissionBanner: true,
          addressToEdit: widget.addressToEdit,
        );
      case PermissionStatusEntity.granted:
        return _buildViewByServiceStatus(
          isLocationEnabled: isServiceEnabled,
          context: context,
          localizations: localizations,
          addressToEdit: widget.addressToEdit,
        );
      case PermissionStatusEntity.restricted:
      case PermissionStatusEntity.limited:
      case PermissionStatusEntity.permanentlyDenied:
      case PermissionStatusEntity.provisional:
        return _buildPermissionBlockedView(
          mainIcon: Icons.lock_outline,
          title: localizations.locationAccessBlocked,
          description: localizations.locationBlockedDescription,
          mainButtonTitle: localizations.openSettings,
          mainButtonAction: () {
            context.read<AddAddressViewModel>().doEvent(OpenAppSettings());
          },
          context: context,
        );
    }
  }
}

Widget _buildViewByServiceStatus({
  required bool isLocationEnabled,
  required BuildContext context,
  required AppLocalizations localizations,
  AddressEntity? addressToEdit,
}) {
  return isLocationEnabled
      ? AddAddressFormView(addressToEdit: addressToEdit)
      : _buildLocationDisabledView(
          context: context,
          mainIcon: Icons.location_off_outlined,
          title: localizations.turnOnLocation,
          description: localizations.locationDisabledDescription,
          mainButtonTitle: localizations.enableLocation,
          mainButtonAction: () {
            context.read<AddAddressViewModel>().doEvent(
              RequestLocationService(),
            );
          },
        );
}

Widget _buildPermissionBlockedView({
  required BuildContext context,
  required IconData mainIcon,
  required String title,
  required String description,
  required String mainButtonTitle,
  required void Function() mainButtonAction,
}) {
  return AddressWarningView(
    mainIcon,
    title,
    description,
    mainButtonTitle,
    mainButtonAction,
  );
}

Widget _buildLocationDisabledView({
  required BuildContext context,
  required IconData mainIcon,
  required String title,
  required String description,
  required String mainButtonTitle,
  required void Function() mainButtonAction,
}) {
  return AddressWarningView(
    mainIcon,
    title,
    description,
    mainButtonTitle,
    mainButtonAction,
  );
}
