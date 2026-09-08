import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/config/session/session_service.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<bool> checkGuestMode(BuildContext context) async {
  final sessionService = getIt<SessionService>();

  final isGuest = await sessionService.isGuest();

  if (!isGuest) {
    return true;
  }

  if (!context.mounted) {
    return false;
  }

  final localizations = AppLocalizations.of(context)!;

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(localizations.loginRequired),
        content: Text(localizations.loginRequiredMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(localizations.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(AppRoutes.login);
            },
            child: Text(localizations.login),
          ),
        ],
      );
    },
  );

  return false;
}
