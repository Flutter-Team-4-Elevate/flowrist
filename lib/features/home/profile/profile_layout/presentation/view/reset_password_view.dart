import 'package:flowrist/config/form_validator/form_validator.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_dimensions.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/ui/widgets/app_text_field.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/change_password_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/cubit/profile_cubit.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/cubit/profile_events.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _currentPasswordController.addListener(_validateInputs);
    _newPasswordController.addListener(_validateInputs);
    _confirmPasswordController.addListener(_validateInputs);
  }

  void _validateInputs() {
    final hasText =
        _currentPasswordController.text.isNotEmpty &&
        _newPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty;
    _isButtonEnabled.value = hasText;
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (prev, current) =>
          prev.changePasswordState != current.changePasswordState,
      listener: (context, state) => _handleState(context, state, l10n),
      child: Scaffold(
        backgroundColor: AppColors.whiteBase,
        appBar: AppBar(
          title: Text(l10n.resetPassword, style: AppStyles.medium18Inter),
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.defaultScreenPadding,
            ),
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.03),
                  AppTextField(
                    label: l10n.currentPassword,
                    hint: l10n.currentPassword,
                    controller: _currentPasswordController,
                    obscureText: true,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return l10n.emptyValidationError;
                      }
                      return null;
                    },
                    localizations: l10n,
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  AppTextField(
                    label: l10n.newPassword,
                    hint: l10n.newPassword,
                    controller: _newPasswordController,
                    obscureText: true,
                    validator: (val) => _validateNewPassword(val, l10n),
                    localizations: l10n,
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  AppTextField(
                    label: l10n.confirmNewPassword,
                    hint: l10n.confirmNewPassword,
                    controller: _confirmPasswordController,
                    obscureText: true,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return l10n.emptyValidationError;
                      }
                      if (val != _newPasswordController.text) {
                        return l10n.passwordsDoNotMatch;
                      }
                      return null;
                    },
                    localizations: l10n,
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  _buildSubmitButton(l10n, screenHeight),
                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validateNewPassword(String? val, AppLocalizations l10n) {
    if (val == null || val.isEmpty) {
      return l10n.emptyValidationError;
    }
    final result = FormValidator.validatePassword(val);
    return switch (result) {
      Valid() => null,
      LengthError() => l10n.passwordLengthError,
      UppercaseError() => l10n.passwordUppercaseError,
      LowercaseError() => l10n.passwordLowercaseError,
      NumberError() => l10n.passwordNumberError,
      SpecialCharError() => l10n.passwordSpecialCharError,
    };
  }

  Widget _buildSubmitButton(AppLocalizations l10n, double screenHeight) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isButtonEnabled,
      builder: (context, isEnabled, _) {
        return SizedBox(
          width: double.infinity,
          height: screenHeight * 0.06,
          child: ElevatedButton(
            onPressed: isEnabled ? () => _onSubmit(context) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.purpleBase,
              disabledBackgroundColor: AppColors.white80,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(l10n.update, style: AppStyles.medium16Inter),
          ),
        );
      },
    );
  }

  void _handleState(
    BuildContext context,
    ProfileState state,
    AppLocalizations l10n,
  ) {
    final changeState = state.changePasswordState;

    if (changeState.isLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(color: AppColors.purpleBase),
        ),
      );
      return;
    }

    Navigator.of(context, rootNavigator: true).maybePop();

    if (changeState.errorMessage != null &&
        changeState.errorMessage!.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(changeState.errorMessage!),
          backgroundColor: AppColors.red,
        ),
      );
    } else if (!changeState.isLoading && changeState.errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.passwordChangedSuccess),
          backgroundColor: AppColors.green,
        ),
      );
      context.go(AppRoutes.login);
    }
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final request = ChangePasswordRequestDto(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
        confirmNewPassword: _confirmPasswordController.text,
      );

      context.read<ProfileCubit>().doEvent(ChangePasswordEvent(request));
    }
  }
}
