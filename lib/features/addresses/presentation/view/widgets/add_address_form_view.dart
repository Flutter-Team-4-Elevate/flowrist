import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/ui/widgets/app_button.dart';
import 'package:flowrist/core/ui/widgets/app_text_field.dart';
import 'package:flowrist/features/addresses/presentation/view/widgets/address_map_widget.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_event.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_state.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/coordinates_entity.dart';

class AddAddressFormView extends StatefulWidget {
  final bool showSoftPermissionBanner;

  const AddAddressFormView({super.key, this.showSoftPermissionBanner = false});

  @override
  State<AddAddressFormView> createState() => _AddAddressFormViewState();
}

class _AddAddressFormViewState extends State<AddAddressFormView> {
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return BlocListener<AddAddressViewModel, AddAddressState>(
      listenWhen: (prev, curr) =>
          curr.userLocation != null &&
          !curr.userLocation!.isLoading &&
          prev.userLocation?.data != curr.userLocation?.data,
      listener: (context, state) {
        _addressController.text = state.userLocation!.data ?? "";
      },
      child: BlocBuilder<AddAddressViewModel, AddAddressState>(
        buildWhen: (prev, curr) =>
            prev.selectedLocation != curr.selectedLocation ||
            prev.isMapConfigured != curr.isMapConfigured ||
            prev.userLocation?.errorMessage != curr.userLocation?.errorMessage,
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMapView(context, localizations, state),
                if (!state.isMapConfigured) _buildMapWarningView(localizations),
                if (state.userLocation != null &&
                    state.userLocation!.errorMessage != null)
                  ..._buildAddressErrorView(
                    context,
                    localizations,
                    state.userLocation!.errorMessage!,
                  ),
                const SizedBox(height: 32),
                ..._buildAddressForm(localizations: localizations),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMapWarningView(AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.amber10,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.amber90,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.mapConfigWarning,
                    style: AppStyles.bold16Amber100.copyWith(fontSize: 13),
                  ),
                  Text(
                    localizations.mapConfigWarningDescription,
                    style: AppStyles.regular13Amber90Height14.copyWith(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapView(
    BuildContext context,
    AppLocalizations localizations,
    AddAddressState state,
  ) {
    return Stack(
      children: [
        AddressMapWidget(
          mapTilerApiKey: context.read<AddAddressViewModel>().mapTilerApiKey,
          selectedLocation: state.selectedLocation!,
          onLocationSelected: (CoordinatesEntity location) {
            context.read<AddAddressViewModel>().doEvent(
              SelectMapLocation(location),
            );
          },
        ),
        if (widget.showSoftPermissionBanner)
          _buildPermissionNeededView(context, localizations),
      ],
    );
  }

  Widget _buildPermissionNeededView(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return Positioned.fill(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.lightPink.withValues(alpha: .95),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.purple70,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.locationPermissionNeeded,
                        style: AppStyles.semiBold16Purple100,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        localizations.allowAccessDescription,
                        style: AppStyles.regular12Purple70,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: SizedBox(
                width: 140,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AddAddressViewModel>().doEvent(
                      RequestLocationPermission(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purpleBase,
                  ),
                  child: Text(
                    localizations.allowAccess,
                    style: AppStyles.medium16Inter.copyWith(
                      fontSize: 14,
                      color: AppColors.whiteBase,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAddressErrorView(
    BuildContext context,
    AppLocalizations localizations,
    String errorMessage,
  ) {
    return [
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.amber10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.amber90,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    errorMessage.isNotEmpty
                        ? errorMessage
                        : localizations.couldntResolveAddress,
                    style: AppStyles.bold16Amber100,
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: AppStyles.regular13Amber90Height14,
                      children: [
                        TextSpan(
                          text: localizations.couldntResolveAddressDescription,
                        ),
                        WidgetSpan(
                          child: InkWell(
                            onTap: () {
                              context.read<AddAddressViewModel>().doEvent(
                                FetchUserLocation(),
                              );
                            },
                            child: Text(
                              localizations.tryAgain,
                              style: AppStyles.bold13Amber100Underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Container _buildLocationLoadingField(AppLocalizations localizations) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.black10.withValues(alpha: .5)),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.purple30),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            localizations.findingLocation,
            style: AppStyles.regular14Inter.copyWith(color: AppColors.black30),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required void Function(String?) onChanged,
  }) {
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
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.black),
          style: AppStyles.regular14Inter.copyWith(color: AppColors.black),
          onChanged: onChanged,
          items: [DropdownMenuItem(value: value, child: Text(value))],
        ),
      ),
    );
  }

  List<Widget> _buildAddressForm({required AppLocalizations localizations}) {
    return [
      BlocBuilder<AddAddressViewModel, AddAddressState>(
        buildWhen: (prev, curr) =>
            prev.userLocation?.isLoading != curr.userLocation?.isLoading ||
            prev.userLocation?.data != curr.userLocation?.data,
        builder: ((context, state) {
          if (state.userLocation == null) return const SizedBox.shrink();

          if (state.userLocation!.isLoading) {
            return _buildLocationLoadingField(localizations);
          } else {
            return AppTextField(
              label: localizations.address,
              hint: localizations.enterAddress,
              controller: _addressController,
              localizations: localizations,
              suffixIcon: IconButton(
                onPressed: () {
                  context.read<AddAddressViewModel>().doEvent(
                    FetchUserLocation(),
                  );
                },
                icon: Icon(Icons.loop_outlined),
              ),
              labelStyle: AppStyles.regular12Inter.copyWith(
                color: AppColors.grey,
              ),
              hintStyle: AppStyles.regular14Inter.copyWith(
                color: AppColors.black10,
              ),
            );
          }
        }),
      ),
      const SizedBox(height: 16),
      AppTextField(
        label: localizations.phoneNumber,
        hint: localizations.enterPhoneNumber,
        localizations: localizations,
        labelStyle: AppStyles.regular12Inter.copyWith(color: AppColors.grey),
        hintStyle: AppStyles.regular14Inter.copyWith(color: AppColors.black10),
        keyboardType: TextInputType.phone,
      ),
      const SizedBox(height: 16),
      AppTextField(
        label: localizations.recipientName,
        hint: localizations.enterRecipientName,
        localizations: localizations,
        labelStyle: AppStyles.regular12Inter.copyWith(color: AppColors.grey),
        hintStyle: AppStyles.regular14Inter.copyWith(color: AppColors.black10),
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: _buildDropdown(
              label: localizations.city,
              value: localizations.cairo,
              onChanged: (val) {},
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildDropdown(
              label: localizations.area,
              value: localizations.october,
              onChanged: (val) {},
            ),
          ),
        ],
      ),
      const SizedBox(height: 48),
      SizedBox(
        width: double.infinity,
        height: 52,
        child: AppButton(
          text: localizations.saveAddress,
          onPressed: () {
            // TODO: Implement save logic
          },
          backgroundColor: AppColors.white80,
        ),
      ),
    ];
  }
}
