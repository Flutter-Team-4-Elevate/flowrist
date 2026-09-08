import 'package:flowrist/config/form_validator/form_validator.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/ui/widgets/app_text_field.dart';
import 'package:flowrist/features/auth/data/models/register_request_dto.dart';
import 'package:flowrist/features/auth/presentation/signup/view_model/signup_event.dart';
import 'package:flowrist/features/auth/presentation/signup/view_model/signup_state.dart';
import 'package:flowrist/features/auth/presentation/signup/view_model/signup_view_model.dart';
import 'package:flowrist/features/auth/presentation/signup/widgets/gender_section.dart';
import 'package:flowrist/features/auth/presentation/signup/widgets/name_fields.dart';
import 'package:flowrist/features/auth/presentation/signup/widgets/password_fields.dart';
import 'package:flowrist/features/auth/presentation/signup/widgets/signup_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Gender _selectedGender = Gender.female;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final screenSize = MediaQuery.sizeOf(context);

    return BlocListener<SignUpViewModel, SignUpState>(
      listener: _handleStateChanges,
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildFormContent(context, localizations, screenSize),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormContent(
    BuildContext context,
    AppLocalizations localizations,
    Size screenSize,
  ) {
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return [
      SizedBox(height: screenHeight * 0.0284),
      NameFields(
        firstNameController: _firstNameController,
        lastNameController: _lastNameController,
        localizations: localizations,
        screenWidth: screenWidth,
      ),
      SizedBox(height: screenHeight * 0.0284),
      _buildEmailField(localizations),
      SizedBox(height: screenHeight * 0.0284),
      PasswordFields(
        passwordController: _passwordController,
        confirmPasswordController: _confirmPasswordController,
        localizations: localizations,
        screenWidth: screenWidth,
      ),
      SizedBox(height: screenHeight * 0.0284),
      _buildPhoneField(localizations),
      SizedBox(height: screenHeight * 0.0284),
      GenderSection(
        selectedGender: _selectedGender,
        onGenderChanged: (gender) {
          setState(() {
            _selectedGender = gender;
          });
        },
        localizations: localizations,
        screenWidth: screenWidth,
      ),
      SizedBox(height: screenHeight * 0.0189),
      _buildTermsAndConditionsText(localizations),
      SizedBox(height: screenHeight * 0.0568),
      SignUpSubmitButton(
        screenHeight: screenHeight,
        localizations: localizations,
        onSubmit: () => _onSubmit(context),
      ),
      SizedBox(height: screenHeight * 0.0189),
      _buildLoginRedirectText(context, localizations),
      SizedBox(height: screenHeight * 0.03),
    ];
  }

  Widget _buildEmailField(AppLocalizations localizations) {
    return AppTextField(
      label: localizations.email,
      hint: localizations.enterEmail,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      validationPattern: FormValidator.emailPattern,
      validationErrorMessage: localizations.invalidEmailError,
      localizations: localizations,
    );
  }

  Widget _buildPhoneField(AppLocalizations localizations) {
    return AppTextField(
      label: localizations.phoneNumber,
      hint: localizations.enterPhoneNumber,
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      validationPattern: FormValidator.phonePattern,
      validationErrorMessage: localizations.generalValidationError,
      localizations: localizations,
    );
  }

  void _handleStateChanges(BuildContext context, SignUpState state) {
    final localizations = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(state.errorMessage!)));
    } else if (state.data != null) {
      messenger.showSnackBar(
        SnackBar(content: Text(localizations.registrationSuccessful)),
      );
      context.go(AppRoutes.login);
    }
  }

  Widget _buildTermsAndConditionsText(AppLocalizations localizations) {
    return Text.rich(
      TextSpan(
        text: localizations.termsAndConditionsPrefix,
        style: AppStyles.regular12Inter,
        children: [
          TextSpan(
            text: localizations.termsAndConditions,
            style: AppStyles.semiBold12Underline,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildLoginRedirectText(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return GestureDetector(
      onTap: () => context.go(AppRoutes.login),
      child: Text.rich(
        TextSpan(
          text: '${localizations.alreadyHaveAccount} ',
          style: AppStyles.regular16,
          children: [
            TextSpan(
              text: localizations.login,
              style: AppStyles.medium16Inter.copyWith(
                color: AppColors.purpleBase,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.purpleBase,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final request = RegisterRequestDto(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        gender: _selectedGender.value,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        fcmToken: 'dummy_fcm_token',
        notificationStatus: 1,
      );

      context.read<SignUpViewModel>().doIntent(SignUpSubmittedEvent(request));
    }
  }
}
