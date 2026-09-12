import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/config/session/session_guard.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatelessWidget {
  final StatefulNavigationShell tabViewShell;

  const HomeView({super.key, required this.tabViewShell});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: tabViewShell,
      bottomNavigationBar: _buildBottomNavigationBar(
        context: context,
        localization: l10n,
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar({
    required BuildContext context,
    required AppLocalizations localization,
  }) {
    return BottomNavigationBar(
      currentIndex: tabViewShell.currentIndex,
      onTap: (index) async {
        if (index == 3 || index == 2) {
          final canContinue = await checkGuestMode(context);

          if (!canContinue) {
            return;
          }
        }

        tabViewShell.goBranch(index);
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          label: localization.home,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category_outlined),
          label: localization.categories,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: localization.cart,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_outlined),
          label: localization.profile,
        ),
      ],
    );
  }
}
