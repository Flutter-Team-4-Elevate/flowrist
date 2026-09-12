import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/config/l10n/cubit/app_language_cubit.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_constants.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/cubit/profile_cubit.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/cubit/profile_events.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/cubit/profile_state.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/view/edit_profile_view.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/view/widgets/change_language_bottom_sheet.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/view/widgets/logout_dialog.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/view/widgets/profile_app_bar.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/view/widgets/profile_header_section.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/view/widgets/profile_menu_item.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/view/widgets/profile_section.dart';
import 'package:flowrist/shared/addresses/presentation/view_model/addresses_event.dart';
import 'package:flowrist/shared/addresses/presentation/view_model/addresses_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileTabView extends StatelessWidget {
  const ProfileTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileCubit>()..doEvent(const GetProfileEvent()),
      child: const _ProfileTabViewContent(),
    );
  }
}

class _ProfileTabViewContent extends StatefulWidget {
  const _ProfileTabViewContent();

  @override
  State<_ProfileTabViewContent> createState() => _ProfileTabViewContentState();
}

class _ProfileTabViewContentState extends State<_ProfileTabViewContent> {
  final ValueNotifier<bool> _isNotificationEnabled = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _isNotificationEnabled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final itemPadding = MediaQuery.sizeOf(context).width * 0.05;

    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (prev, current) => prev.logoutState != current.logoutState,
      listener: _handleLogoutState,
      child: Scaffold(
        backgroundColor: AppColors.whiteBase,
        body: SafeArea(
          child: Column(
            children: [
              ProfileAppBar(onNotificationTap: () {}),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _buildHeaderSection(context),
                      _buildOrdersAndAddresses(context, l10n, itemPadding),
                      _buildNotificationsSection(context, l10n, itemPadding),
                      _buildSettingsSection(context, l10n, itemPadding),
                      _buildLogoutSection(context, l10n, itemPadding),
                      SizedBox(height: screenHeight * 0.03),
                      Text(l10n.app_version, style: AppStyles.regular12Inter),
                      SizedBox(height: screenHeight * 0.02),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (prev, current) => prev.profileState != current.profileState,
      builder: (context, state) {
        final profile = state.profileState.data;

        return ProfileHeaderSection(
          userName: profile != null && profile.fullName.isNotEmpty
              ? profile.fullName
              : '',
          userEmail: profile?.email ?? '',
          onEditName: () {
            if (profile != null) {
              final profileCubit = context.read<ProfileCubit>();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: profileCubit,
                    child: EditProfileView(userProfile: profile),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  void _handleLogoutState(BuildContext context, ProfileState state) {
    if (state.logoutState.isLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(color: AppColors.purpleBase),
        ),
      );
    } else {
      Navigator.of(context, rootNavigator: true).maybePop();
      if (!state.logoutState.isLoading) {
        context.go(AppRoutes.login);
      }
    }
  }

  Widget _buildOrdersAndAddresses(
    BuildContext context,
    AppLocalizations l10n,
    double itemPadding,
  ) {
    return ProfileSection(
      children: [
        ProfileMenuItem(
          horizontalPadding: itemPadding,
          icon: Icons.assignment_outlined,
          title: l10n.myOrders,
          onTap: () => context.push(AppRoutes.myOrders),
        ),
        ProfileMenuItem(
          horizontalPadding: itemPadding,
          icon: Icons.location_on_outlined,
          title: l10n.saveAddress,
          onTap: () async {
            final addressesViewModel = context.read<AddressesViewModel>();
            final result = await context.push(AppRoutes.savedAddresses);
            if (result == true && mounted) {
              addressesViewModel.doEvent(RefreshAddresses());
            }
          },
        ),
        ProfileMenuItem(
          horizontalPadding: itemPadding,
          icon: Icons.devices_outlined,
          title: l10n.activeSessions,
          onTap: () => context.push(AppRoutes.activeSessions),
        ),
      ],
    );
  }

  Widget _buildNotificationsSection(
    BuildContext context,
    AppLocalizations l10n,
    double itemPadding,
  ) {
    return ProfileSection(
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: itemPadding),
          horizontalTitleGap: 0,
          leading: Transform.scale(
            scale: 0.7,
            alignment: AlignmentDirectional.centerStart,
            child: ValueListenableBuilder<bool>(
              valueListenable: _isNotificationEnabled,
              builder: (context, isEnabled, _) {
                return Switch(
                  value: isEnabled,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  activeThumbColor: AppColors.white,
                  activeTrackColor: AppColors.purpleBase,
                  onChanged: (val) => _isNotificationEnabled.value = val,
                );
              },
            ),
          ),
          title: Text(
            l10n.notification,
            style: AppStyles.regular14Inter.copyWith(
              color: AppColors.blackBase,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: AppColors.grey,
            size: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    AppLocalizations l10n,
    double itemPadding,
  ) {
    final currentLocale = context.watch<AppLanguageCubit>().state.languageCode;
    final currentLanguageText = currentLocale == 'ar'
        ? l10n.arabic
        : l10n.english;

    return ProfileSection(
      children: [
        ProfileMenuItem(
          horizontalPadding: itemPadding,
          icon: Icons.translate,
          title: l10n.language,
          trailing: Text(
            currentLanguageText,
            style: AppStyles.regular13W500.copyWith(
              color: AppColors.purpleBase,
            ),
          ),
          onTap: () => ChangeLanguageBottomSheet.show(context),
        ),
        ProfileMenuItem(
          horizontalPadding: itemPadding,
          icon: Icons.info_outline,
          title: l10n.about_us,
          onTap: () {
            context.push(
              AppRoutes.webView,
              extra: {
                AppConstants.title: l10n.about_us,
                AppConstants.url: AppConstants.aboutUsUrl,
              },
            );
          },
        ),
        ProfileMenuItem(
          horizontalPadding: itemPadding,
          icon: Icons.description_outlined,
          title: l10n.terms_and_conditions,
          onTap: () {
            context.push(
              AppRoutes.webView,
              extra: {
                AppConstants.title: l10n.terms_and_conditions,
                AppConstants.url: AppConstants.termsAndConditionsUrl,
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildLogoutSection(
    BuildContext context,
    AppLocalizations l10n,
    double itemPadding,
  ) {
    return ProfileSection(
      showBottomDivider: false,
      children: [
        ProfileMenuItem(
          horizontalPadding: itemPadding,
          icon: Icons.logout,
          title: l10n.logOut,
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: AppColors.grey,
            size: 16,
          ),
          onTap: () => LogoutDialog.show(
            context,
            onConfirm: () =>
                context.read<ProfileCubit>().doEvent(const LogoutEvent()),
          ),
        ),
      ],
    );
  }
}
