import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/config/notifications/notification_service.dart';
import 'package:flowrist/config/session/session_service.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/features/splash/presentation/view/flower.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  static const _splashDuration = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();

    _checkSession();
    _requestNotificationPermission();
  }

  Future<void> _requestNotificationPermission() async {
    final pushNotifications = getIt<PushNotificationsServices>();

    await pushNotifications.requestPermission();
  }

  Future<void> _checkSession() async {
    await Future.delayed(_splashDuration);

    if (!mounted) return;

    final sessionService = getIt<SessionService>();

    try {
      final isRemembered = await sessionService.isRemembered();

      if (!mounted) return;

      if (isRemembered) {
        context.go(AppRoutes.homeTab);
      } else {
        context.go(AppRoutes.login);
      }
    } catch (error) {
      debugPrint('Splash session check failed: $error');

      if (!mounted) return;

      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: FlowerView(),
    );
  }
}