import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/features/addresses/presentation/view/widgets/add_address_form_view.dart';
import 'package:flowrist/features/addresses/presentation/view/widgets/address_warning_view.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_event.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_state.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/permission_status_entity.dart';

class AddAddressView extends StatefulWidget {
  const AddAddressView({super.key});

  @override
  State<AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<AddAddressView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<AddAddressViewModel>().doEvent(CheckLocationPermission());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<AddAddressViewModel>().doEvent(CheckLocationPermission());
      context.read<AddAddressViewModel>().doEvent(CheckLocationService());
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            context.pop();
          },
          child: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        titleSpacing: 0,
        title: Text(localizations.address, style: AppStyles.bold20Inter),
      ),
      body: BlocBuilder<AddAddressViewModel, AddAddressState>(
        buildWhen: (prev, curr) =>
            prev.locationPermission != curr.locationPermission ||
            prev.locationEnabled != curr.locationEnabled,
        builder: ((context, state) {
          if (state.locationPermission.isLoading) {
            return _loadingView();
          } else {
            return _buildViewByPermissionStatus(
              permissionStatus:
                  state.locationPermission.data ??
                  PermissionStatusEntity.denied,
              isServiceEnabled: state.locationEnabled,
              localizations: localizations,
            );
          }
        }),
      ),
    );
  }

  Widget _loadingView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildViewByPermissionStatus({
    required PermissionStatusEntity permissionStatus,
    required bool isServiceEnabled,
    required AppLocalizations localizations,
  }) {
    switch (permissionStatus) {
      case PermissionStatusEntity.denied:
        return AddAddressFormView(showSoftPermissionBanner: true);
      case PermissionStatusEntity.granted:
        return _buildViewByServiceStatus(
          isLocationEnabled: isServiceEnabled,
          context: context,
          localizations: localizations,
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
}) {
  return isLocationEnabled
      ? AddAddressFormView()
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
