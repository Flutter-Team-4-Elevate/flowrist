import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/config/session/session_service.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/ui/widgets/app_button.dart';
import 'package:flowrist/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:flowrist/features/auth/presentation/login/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileTabView extends StatelessWidget {
  const ProfileTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: Text('Profile Tab')),
          const SizedBox(height: 24),
          AppButton(
            text: 'Saved Address',
            onPressed: () {
              context.push(AppRoutes.savedAddresses);
            },
          ),
          const SizedBox(height: 16),
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
            child: const Text("data"),
          ),
        ],
      ),
    );
  }
}
