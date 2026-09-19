import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/features/auth/presentation/signup/view_model/signup_state.dart';
import 'package:flowrist/features/auth/presentation/signup/view_model/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpSubmitButton extends StatelessWidget {
  final double screenHeight;
  final AppLocalizations localizations;
  final VoidCallback onSubmit;

  const SignUpSubmitButton({
    super.key,
    required this.screenHeight,
    required this.localizations,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpViewModel, SignUpState>(
      builder: (context, state) {
        return SizedBox(
          height: screenHeight * 0.06,
          child: ElevatedButton(
            onPressed: state.isLoading ? null : onSubmit,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: _buildButtonChild(state.isLoading),
          ),
        );
      },
    );
  }

  Widget _buildButtonChild(bool isLoading) {
    if (!isLoading) return Text(localizations.signup);

    return const SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        color: AppColors.whiteBase,
        strokeWidth: 2,
      ),
    );
  }
}
