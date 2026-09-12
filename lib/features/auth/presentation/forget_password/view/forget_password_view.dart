import 'package:flowrist/features/auth/presentation/forget_password/widgets/forget_password_otp_view.dart';
import 'package:flowrist/features/auth/presentation/forget_password/widgets/reset_password_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_model/forget_password_state.dart';
import '../view_model/forget_password_view_model.dart';
import '../widgets/forget_password_email_view.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _changePage(ForgetPasswordStep step) {
    final page = switch (step) {
      ForgetPasswordStep.email => 0,
      ForgetPasswordStep.otp => 1,
      ForgetPasswordStep.resetPassword => 2,
    };

    if (!_pageController.hasClients) {
      return;
    }

    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: BlocListener<ForgetPasswordBloc, ForgetPasswordState>(
        listenWhen: (previous, current) => previous.step != current.step,
        listener: (context, state) {
          _changePage(state.step);
        },
        child: PageView(
          controller: _pageController,

          // VERY IMPORTANT
          // User cannot swipe between steps.
          physics: const NeverScrollableScrollPhysics(),

          children: const [
            ForgetPasswordEmailView(),
            ForgetPasswordOtpView(),
            ResetPasswordView(),
          ],
        ),
      ),
    );
  }
}
