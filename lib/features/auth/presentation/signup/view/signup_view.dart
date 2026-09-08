import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_dimensions.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/features/auth/presentation/signup/view_model/signup_view_model.dart';
import 'package:flowrist/features/auth/presentation/signup/widgets/sign_up_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => getIt<SignUpViewModel>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations.signup, style: AppStyles.medium20),
          titleSpacing: AppDimensions.defaultScreenPadding,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.defaultScreenPadding,
            ),
            child: const SignUpForm(),
          ),
        ),
      ),
    );
  }
}
