import 'dart:async';
import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/config/form_validator/form_validator.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_dimensions.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/ui/widgets/app_button.dart';
import 'package:flowrist/core/ui/widgets/app_text_field.dart';
import 'package:flowrist/features/auth/presentation/login/cubit/login_event.dart';
import 'package:flowrist/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:flowrist/features/auth/presentation/login/cubit/login_state.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_cubit.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_event.dart';
import 'package:flowrist/features/home/cart/presentation/helpers/pending_cart_action_store.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final StreamSubscription<LoginUIEvent> _subscription;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> obscurePassword = ValueNotifier(true);

  void checkFormValidity() {
    context.read<LoginCubit>().doEvent(
      FormValidityChanged(_formKey.currentState?.validate() ?? false),
    );
  }

  @override
  void dispose() {
    obscurePassword.dispose();
    _subscription.cancel();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final loginCubit = context.read<LoginCubit>();

    _subscription = loginCubit.uiStream.listen((event) {
      if (!mounted) {
        return;
      }
      switch (event) {
        case ShowMessage():
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                event.message == 'loginSuccessfully'
                    ? AppLocalizations.of(context)!.loginSuccessfully
                    : event.message,
              ),
            ),
          );

        case LoginSuccess():
          final cartCubit = context.read<CartCubit>();
          cartCubit.doIntent(GetCartEvent());
          getIt<PendingCartActionStore>().executePendingActionIfAny(cartCubit);
          context.go(AppRoutes.homeTab);

        case GuestLoginSuccess():
          context.go(AppRoutes.homeTab);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: ListView(
          children: [
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding: const EdgeInsets.all(
                  AppDimensions.defaultScreenPadding,
                ),
                child: Column(
                  children: [
                    AppTextField(
                      label: localizations.email,
                      hint: localizations.emailHint,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      validationPattern: FormValidator.emailPattern,
                      validationErrorMessage:
                          localizations.generalValidationError,
                      localizations: localizations,
                      onChange: (_) => checkFormValidity(),
                    ),
                    const SizedBox(height: 20),
                    ValueListenableBuilder<bool>(
                      valueListenable: obscurePassword,
                      builder: (context, isObscure, child) {
                        return AppTextField(
                          label: "Password",
                          hint: "Enter your password",
                          controller: passwordController,
                          obscureText: isObscure,
                          suffixIcon: IconButton(
                            onPressed: () {
                              obscurePassword.value = !obscurePassword.value;
                            },
                            icon: Icon(
                              isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 18,
                            ),
                          ),
                          localizations: localizations,
                          onChange: (_) => checkFormValidity(),
                        );
                      },
                    ),

                    BlocBuilder<LoginCubit, LoginState>(
                      buildWhen: (previous, current) =>
                          previous.rememberMe != current.rememberMe,
                      builder: (context, state) {
                        return Row(
                          children: [
                            Checkbox(
                              value: state.rememberMe,
                              onChanged: (value) {
                                context.read<LoginCubit>().doEvent(
                                  RememberMeChanged(value ?? false),
                                );
                              },
                            ),
                            Text(
                              localizations.rememberMe,
                              style: AppStyles.regular13,
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                context.go(AppRoutes.homeTab);
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                localizations.forgetPassword,
                                style: AppStyles.regular12Underline,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 70),
                    BlocBuilder<LoginCubit, LoginState>(
                      buildWhen: (previous, current) =>
                          previous.login.isLoading != current.login.isLoading,
                      builder: (context, state) {
                        return SizedBox(
                          width: double.infinity,
                          child: AppButton(
                            text: localizations.login,
                            isLoading: state.login.isLoading,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<LoginCubit>().doEvent(
                                  LoginSubmitted(
                                    email: emailController.text.trim(),
                                    password: passwordController.text,
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        text: localizations.continueAsGuest,
                        onPressed: () {
                          context.read<LoginCubit>().doEvent(ContinueAsGuest());
                        },
                        backgroundColor: AppColors.whiteBase,
                        borderColor: AppColors.blackBase,
                        textColor: AppColors.blackBase,
                      ),
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        style: AppStyles.regular16,
                        children: [
                          TextSpan(text: localizations.dontHaveAccount),
                          TextSpan(
                            text: localizations.signUp,
                            style: AppStyles.medium16InterUnderline,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.push(AppRoutes.signUp);
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
