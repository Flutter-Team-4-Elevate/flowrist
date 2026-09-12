import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/config/session/session_service.dart';
import 'package:flowrist/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:flowrist/features/auth/presentation/login/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileTabView extends StatelessWidget {
  const ProfileTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Text('Profile Tab')),
        ElevatedButton(
          onPressed: () async {
            final tokenService = getIt<SessionService>();
            await tokenService.clearSession();

            if (!context.mounted) return;

        Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => BlocProvider(
      create: (_) => getIt<LoginCubit>(),
      child: const LoginView(),
    ),
  ),
);
          },
          child: Text("data"),
        ),
      ],
    );
  }
}
