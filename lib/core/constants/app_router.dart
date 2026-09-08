import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/features/addresses/presentation/view/add_address_view.dart';
import 'package:flowrist/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:flowrist/features/auth/presentation/login/view/login_view.dart';
import 'package:flowrist/features/auth/presentation/signup/view/signup_view.dart';
import 'package:flowrist/features/home/cart/presentation/view/cart_tab_view.dart';
import 'package:flowrist/features/home/categories/presentation/cubit/categories_cubit.dart';
import 'package:flowrist/features/home/categories/presentation/cubit/categories_events.dart';
import 'package:flowrist/features/home/categories/presentation/view/categories_tab_view.dart';
import 'package:flowrist/features/home/home/presentation/best_seller/cubit/best_seller_cubit.dart';
import 'package:flowrist/features/home/home/presentation/best_seller/view/best_seller_view.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/view/home_tab_view.dart';
import 'package:flowrist/features/home/home/presentation/occasion/cubit/occasion_cubit.dart';
import 'package:flowrist/features/home/home/presentation/occasion/view/occasion_view.dart';
import 'package:flowrist/features/home/profile/presentation/view/profile_tab_view.dart';
import 'package:flowrist/features/home/shared/home_navigation_view.dart';
import 'package:flowrist/features/splash/presentation/view/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/addresses/presentation/view_model/add_address_view_model.dart';
import '../../features/home/shared/product_details/presentation/view/products_details_screen.dart';

abstract final class AppRoutes {
  static const splash = '/';

  static const login = '/login';
  static const signUp = '/sign-up';

  static const homeTab = '/home-tab';
  static const categoriesTab = '/categories-tab';
  static const cartTab = '/cart-tab';
  static const profileTab = '/profile-tab';
  static const productDetails = '/product/:productId';

  static String productDetailsPath(String productId) {
    return '/product/$productId';
  }

  static const String forgetPassword = '/forgot-password';

  static const bestSeller = '/best-seller';
  static const occasions = '/occasions';
  static const addAddress = '/add-address';
}

abstract final class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.productDetails,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final productId = state.pathParameters['productId'];

          if (productId == null || productId.isEmpty) {
            return const Scaffold(
              body: Center(child: Text('Product ID is required')),
            );
          }

          return ProductDetailsScreen(productId: productId);
        },
      ),
      // --------------------------------------------------
      // Splash
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.splash,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return const SplashView();
        },
      ),

      // --------------------------------------------------
      // Login
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.login,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt<LoginCubit>(),
            child: const LoginView(),
          );
        },
      ),

      // --------------------------------------------------
      // Sign Up
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.signUp,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return const SignUpView();
        },
      ),

      // --------------------------------------------------
      // Best Seller
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.bestSeller,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt<BestSellerCubit>(),
            child: const BestSellerView(),
          );
        },
      ),

      // --------------------------------------------------
      // Occasions
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.occasions,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra;

          final data = extra is Map<String, dynamic>
              ? extra
              : <String, dynamic>{};

          return BlocProvider(
            create: (_) => getIt<OccasionCubit>(),
            child: OccasionView(
              occasionId: data['occasionId'] as String?,
              initialIndex: 0,
            ),
          );
        },
      ),

      // ==================================================
      // MAIN APP SHELL
      // ==================================================
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BlocProvider(
            create: (_) =>
                getIt<CategoriesCubit>()..doEvent(GetCategoriesEvent()),
            child: HomeNavigationView(tabViewShell: navigationShell),
          );
        },

        branches: [
          // ------------------------------------------------
          // HOME
          // ------------------------------------------------
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.homeTab,
                builder: (context, state) {
                  return const HomeTabView();
                },
              ),
            ],
          ),

          // ------------------------------------------------
          // CATEGORIES
          // ------------------------------------------------
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.categoriesTab,
                builder: (context, state) {
                  return const CategoriesTabView();
                },
              ),
            ],
          ),

          // ------------------------------------------------
          // CART
          // ------------------------------------------------
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.cartTab,
                builder: (context, state) {
                  return const CartTabView();
                },
              ),
            ],
          ),

          // ------------------------------------------------
          // PROFILE
          // ------------------------------------------------
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profileTab,
                builder: (context, state) {
                  return const ProfileTabView();
                },
              ),
            ],
          ),
        ],
      ),

      // --------------------------------------------------
      // Add Address Screen
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.addAddress,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return BlocProvider<AddAddressViewModel>(
            create: (context) => getIt<AddAddressViewModel>(),
            child: const AddAddressView(),
          );
        },
      ),
    ],
  );
}
