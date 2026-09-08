import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/config/session/session_service.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:flowrist/features/auth/presentation/login/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileTabView extends StatelessWidget {
  const ProfileTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Profile Tab',
              style: AppStyles.bold20Inter,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purpleBase,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                context.push(AppRoutes.myOrders);
              },
              icon: const Icon(
                Icons.shopping_bag_outlined,
                color: AppColors.whiteBase,
              ),
              label: Text(l10n.myOrders, style: AppStyles.medium16Inter),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purpleBase,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                context.push(AppRoutes.activeSessions);
              },
              icon: const Icon(
                Icons.devices_outlined,
                color: AppColors.whiteBase,
              ),
              label: Text(l10n.activeSessions, style: AppStyles.medium16Inter),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.red,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
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
              child: Text(l10n.logOut, style: AppStyles.medium16Inter),
            ),
          ],
        ),
      ),
    );
  }
}
