import 'package:flowrist/config/form_validator/form_validator.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/ui/widgets/app_text_field.dart';
import '../view_model/forget_password_event.dart';
import '../view_model/forget_password_state.dart';
import '../view_model/forget_password_view_model.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validatePassword(
      String? value,
      AppLocalizations localizations,
      ) {
    if (value == null || value.isEmpty) {
      return localizations.enterNewPassword;
    }

    return switch (FormValidator.validatePassword(value)) {
      Valid() => null,
      LengthError() => localizations.passwordMustBeAtLeast8Characters,
      UppercaseError() => localizations.passwordMustContainUppercase,
      LowercaseError() => localizations.passwordMustContainLowercase,
      NumberError() => localizations.passwordMustContainNumber,
      SpecialCharError() => localizations.passwordMustContainSpecialCharacter,
    };
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocListener<ForgetPasswordBloc, ForgetPasswordState>(
      listener: (context, state) {
        if (!state.isLoading && 
        state.operation == ForgetPasswordOperation.resetPassword) {
          if (state.errorMessage == null || state.errorMessage!.isEmpty) {
            AppRouter.router.go(AppRoutes.login);
          } else {
            
          }
        }
      },
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 40),
      
            Text(
              localizations.createNewPassword,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
      
            const SizedBox(height: 40),
      
            AppTextField(
              label: localizations.newPassword,
              hint: localizations.enterNewPassword,
              controller: _passwordController,
              localizations: localizations,
              obscureText: _obscurePassword,
              validator: (value) =>
                  _validatePassword(value, localizations),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
      
            const SizedBox(height: 20),
      
            AppTextField(
              label: localizations.confirmPassword,
              hint: localizations.confirmYourPassword,
              controller: _confirmPasswordController,
              localizations: localizations,
              obscureText: _obscureConfirmPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localizations.confirmYourPassword;
                }
      
                if (value != _passwordController.text) {
                  return localizations.passwordsDoNotMatch;
                }
      
                return null;
              },
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword =
                    !_obscureConfirmPassword;
                  });
                },
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
      
            const SizedBox(height: 24),
      
            BlocBuilder<ForgetPasswordBloc, ForgetPasswordState>(
              builder: (context, state) {
                final isLoading =
                    state.isLoading &&
                        state.operation ==
                            ForgetPasswordOperation.resetPassword;
      
                return SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
      
                      context.read<ForgetPasswordBloc>().add(
                        ResetPasswordEvent(
                          _passwordController.text,
                        ),
                      );
                    },
                    child: isLoading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                        : Text(localizations.resetPassword),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}