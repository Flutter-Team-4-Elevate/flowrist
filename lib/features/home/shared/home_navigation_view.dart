import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/config/session/session_guard.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_cubit.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeNavigationView extends StatelessWidget {
  final StatefulNavigationShell tabViewShell;

  const HomeNavigationView({super.key, required this.tabViewShell});

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

          if (!canContinue || !context.mounted) {
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
          icon: const Icon(Icons.category_outlined),
          label: localization.categories,
        ),
        BottomNavigationBarItem(
          icon: BlocBuilder<CartCubit, CartState>(
            buildWhen: (prev, curr) => prev.totalQuantity != curr.totalQuantity,
            builder: (context, state) {
              final count = state.totalQuantity;

              return Badge(
                isLabelVisible: count > 0,
                label: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Text(
                    '$count',
                    key: ValueKey<int>(count),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                child: const Icon(Icons.shopping_cart_outlined),
              );
            },
          ),
          label: localization.cart,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person_outline_outlined),
          label: localization.profile,
        ),
      ],
    );
  }
}
