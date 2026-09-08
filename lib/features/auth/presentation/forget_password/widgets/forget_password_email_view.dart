import 'package:flowrist/config/form_validator/form_validator.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/ui/widgets/app_text_field.dart';
import '../view_model/forget_password_event.dart';
import '../view_model/forget_password_state.dart';
import '../view_model/forget_password_view_model.dart';

class ForgetPasswordEmailView extends StatefulWidget {
  const ForgetPasswordEmailView({super.key});

  @override
  State<ForgetPasswordEmailView> createState() =>
      _ForgetPasswordEmailPageState();
}

class _ForgetPasswordEmailPageState extends State<ForgetPasswordEmailView> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 40),

          Text(
            localizations.forgotPassword,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          Text(localizations.forgotPasswordDescription),

          const SizedBox(height: 40),

          AppTextField(
            label: localizations.email,
            hint: localizations.enterYourEmail,
            controller: _emailController,
            localizations: localizations,
            validationPattern: FormValidator.emailPattern,
            validationErrorMessage: localizations.invalidEmail,
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 24),

          BlocBuilder<ForgetPasswordBloc, ForgetPasswordState>(
            builder: (context, state) {
              final isLoading =
                  state.isLoading &&
                  state.operation == ForgetPasswordOperation.checkEmail;

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
                            CheckEmailEvent(_emailController.text.trim()),
                          );
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(localizations.sendOtp),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
