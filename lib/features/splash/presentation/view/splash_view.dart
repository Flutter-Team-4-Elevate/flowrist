import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/config/session/session_service.dart';
import 'package:flowrist/core/constants/app_dimensions.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/gallery_view.dart';
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
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: AppDimensions.defaultScreenPadding,
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        title: const Text('Gallery Screen'),
      ),
      body: const GalleryView(),
    );
  }
}