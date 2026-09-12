import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_constants.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/ui/widgets/app_button.dart';
import 'package:flowrist/core/ui/widgets/app_dropdown.dart';
import 'package:flowrist/core/ui/widgets/app_text_field.dart';
import 'package:flowrist/features/addresses/presentation/view/widgets/address_map_widget.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_event.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_state.dart';
import 'package:flowrist/features/addresses/presentation/view_model/add_address_view_model.dart';
import 'package:flowrist/shared/domain/entities/city_entity.dart';
import 'package:flowrist/shared/domain/entities/governorate_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/add_address_request_model.dart';
import '../../../domain/entities/coordinates_entity.dart';

class AddAddressFormView extends StatefulWidget {
  final bool showSoftPermissionBanner;

  const AddAddressFormView({super.key, this.showSoftPermissionBanner = false});

  @override
  State<AddAddressFormView> createState() => _AddAddressFormViewState();
}

class _AddAddressFormViewState extends State<AddAddressFormView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return BlocListener<AddAddressViewModel, AddAddressState>(
      listener: (context, state) {
        if (state.userLocation != null &&
            !state.userLocation!.isLoading &&
            state.userLocation!.data != null) {
          _addressController.text = state.userLocation!.data!;
        }

        if (!state.saveAddressState.isLoading &&
            state.saveAddressState.data == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(localizations.addressSavedSuccessfully)),
          );
          Navigator.of(context).pop();
        } else if (!state.saveAddressState.isLoading &&
            state.saveAddressState.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.saveAddressState.errorMessage ??
                    localizations.generalValidationError,
              ),
            ),
          );
        }
      },
      child: BlocBuilder<AddAddressViewModel, AddAddressState>(
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMapView(context, localizations, state),
                  if (!state.isMapConfigured)
                    _buildMapWarningView(localizations),
                  if (state.userLocation != null &&
                      state.userLocation!.errorMessage != null)
                    ..._buildAddressErrorView(
                      context,
                      localizations,
                      state.userLocation!.errorMessage!,
                    ),
                  const SizedBox(height: 32),
                  ..._buildAddressForm(
                    localizations: localizations,
                    state: state,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
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
        BlocBuilder<AddAddressViewModel, AddAddressState>(
          buildWhen: (prev, curr) =>
              prev.selectedLocation != curr.selectedLocation,
          builder: (context, state) => AddressMapWidget(
            mapTilerApiKey: context.read<AddAddressViewModel>().mapTilerApiKey,
            selectedLocation: state.selectedLocation,
            onLocationSelected: (CoordinatesEntity location) {
              context.read<AddAddressViewModel>().doEvent(
                SelectMapLocation(location),
              );
            },
          ),
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

  List<Widget> _buildAddressForm({
    required AppLocalizations localizations,
    required AddAddressState state,
  }) {
    return [
      BlocBuilder<AddAddressViewModel, AddAddressState>(
        buildWhen: (prev, curr) => prev.userLocation != curr.userLocation,
        builder: (context, state) {
          return state.userLocation != null && state.userLocation!.isLoading
              ? _buildLocationLoadingField(localizations)
              : AppTextField(
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
        },
      ),
      const SizedBox(height: 16),
      AppTextField(
        label: localizations.phoneNumber,
        hint: localizations.enterPhoneNumber,
        controller: _phoneController,
        localizations: localizations,
        labelStyle: AppStyles.regular12Inter.copyWith(color: AppColors.grey),
        hintStyle: AppStyles.regular14Inter.copyWith(color: AppColors.black10),
        keyboardType: TextInputType.phone,
      ),
      const SizedBox(height: 16),
      AppTextField(
        label: localizations.recipientName,
        hint: localizations.enterRecipientName,
        controller: _nameController,
        localizations: localizations,
        labelStyle: AppStyles.regular12Inter.copyWith(color: AppColors.grey),
        hintStyle: AppStyles.regular14Inter.copyWith(color: AppColors.black10),
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: BlocBuilder<AddAddressViewModel, AddAddressState>(
              buildWhen: (prev, curr) =>
                  prev.governoratesState != curr.governoratesState ||
                  prev.selectedGovernorate != curr.selectedGovernorate,
              builder: (context, state) {
                return AppDropdown<GovernorateEntity>(
                  label: localizations.city,
                  hint: localizations.city,
                  value: state.selectedGovernorate,
                  items: state.governoratesState.data ?? [],
                  itemLabelBuilder: (gov) =>
                      localizations.localeName == AppConstants.arabicLocaleCode
                      ? gov.nameAr ?? ''
                      : gov.nameEn ?? '',
                  isLoading: state.governoratesState.isLoading,
                  error: state.governoratesState.errorMessage,
                  onChanged: (gov) {
                    if (gov != null) {
                      context.read<AddAddressViewModel>().doEvent(
                        SelectGovernorateEvent(gov),
                      );
                    }
                  },
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: BlocBuilder<AddAddressViewModel, AddAddressState>(
              buildWhen: (prev, curr) =>
                  prev.citiesState != curr.citiesState ||
                  prev.selectedCity != curr.selectedCity,
              builder: (context, state) {
                return AppDropdown<CityEntity>(
                  label: localizations.area,
                  hint: localizations.area,
                  value: state.selectedCity,
                  items: state.citiesState.data ?? [],
                  itemLabelBuilder: (city) =>
                      localizations.localeName == AppConstants.arabicLocaleCode
                      ? city.nameAr ?? ''
                      : city.nameEn ?? '',
                  isLoading: state.citiesState.isLoading,
                  error: state.citiesState.errorMessage,
                  onChanged: (city) {
                    if (city != null) {
                      context.read<AddAddressViewModel>().doEvent(
                        SelectCityEvent(city),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      const SizedBox(height: 48),
      BlocBuilder<AddAddressViewModel, AddAddressState>(
        builder: (context, state) {
          return SizedBox(
            width: double.infinity,
            height: 52,
            child: AppButton(
              text: localizations.saveAddress,
              isLoading: state.saveAddressState.isLoading,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (state.selectedGovernorate == null ||
                      state.selectedCity == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(localizations.selectCityAndArea)),
                    );
                    return;
                  }

                  final request = AddAddressRequestModel(
                    recipientName: _nameController.text,
                    recipientPhone: _phoneController.text,
                    addressLine: _addressController.text,
                    governorateId: state.selectedGovernorate!.id!,
                    cityId: state.selectedCity!.id!,
                    // TODO: wait for the backend team's response regarding what to send in this field of the request
                    area: state.selectedCity!.nameEn!,
                    lat: state.selectedLocation?.latitude ?? 0.0,
                    lng: state.selectedLocation?.longitude ?? 0.0,
                    label: "home",
                  );
                  context.read<AddAddressViewModel>().doEvent(
                    SaveAddressEvent(request),
                  );
                }
              },
            ),
          );
        },
      ),
    ];
  }
}
