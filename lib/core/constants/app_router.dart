import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/config/session/session_invalidation_notifier.dart';
import 'package:flowrist/config/session/session_service.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_constants.dart';
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
import 'package:flowrist/features/home/profile/my_orders/presentation/view/my_orders_view.dart';
import 'package:flowrist/features/home/profile/my_orders/presentation/view/order_details_view.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/view/profile_tab_view.dart';
import 'package:flowrist/features/home/profile/session_management/presentation/cubit/sessions_cubit.dart';
import 'package:flowrist/features/home/profile/session_management/presentation/view/active_sessions_view.dart';
import 'package:flowrist/features/home/search_and_filtering/search/presentation/view/search_view.dart';
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

  static const forgetPassword = '/forgot-password';

  static const search = '/search';
  static const bestSeller = '/best-seller';
  static const occasions = '/occasions';
  static const addAddress = '/add-address';
  static const activeSessions = '/active-sessions';
  static const myOrders = '/my-orders';
  static const orderDetails = '/order-details/:${AppConstants.orderIdParam}';
  static String orderDetailsPath(String orderId) {
    return '/order-details/$orderId';
  }
}

abstract final class AppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: getIt<SessionInvalidationNotifier>(),
    redirect: (context, state) async {
      final sessionService = getIt<SessionService>();
      final token = await sessionService.getToken();

      final isAuthFlow =
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.signUp ||
          state.matchedLocation == AppRoutes.splash ||
          state.matchedLocation == AppRoutes.forgetPassword;

      if (token.isEmpty && !isAuthFlow) {
        return AppRoutes.login;
      }

      return null;
    },

    routes: [
      // ==================================================
      // PRODUCT DETAILS
      // ==================================================
      GoRoute(
        path: AppRoutes.productDetails,
        parentNavigatorKey: rootNavigatorKey,
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
      // Search
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.search,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SearchView(),
      ),

      // --------------------------------------------------
      // Splash
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.splash,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          return const SplashView();
        },
      ),

      // --------------------------------------------------
      // Login
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.login,
        parentNavigatorKey: rootNavigatorKey,
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
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          return const SignUpView();
        },
      ),

      // --------------------------------------------------
      // Best Seller
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.bestSeller,
        parentNavigatorKey: rootNavigatorKey,
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
        parentNavigatorKey: rootNavigatorKey,
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
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          return BlocProvider<AddAddressViewModel>(
            create: (context) => getIt<AddAddressViewModel>(),
            child: const AddAddressView(),
          );
        },
      ),

      // --------------------------------------------------
      // Active Sessions Screen
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.activeSessions,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          return BlocProvider<SessionsCubit>(
            create: (_) => getIt<SessionsCubit>(),
            child: const ActiveSessionsView(),
          );
        },
      ),

      // --------------------------------------------------
      // My Orders Screen
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.myOrders,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const MyOrdersView(),
      ),

      // --------------------------------------------------
      // Order Details Screen
      // --------------------------------------------------
      GoRoute(
        path: AppRoutes.orderDetails,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final orderId = state.pathParameters[AppConstants.orderIdParam];
          if (orderId == null || orderId.isEmpty) {
            final l10n = AppLocalizations.of(context)!;
            return Scaffold(body: Center(child: Text(l10n.orderIdRequired)));
          }
          return OrderDetailsView(orderId: orderId);
        },
      ),
    ],
  );
}
