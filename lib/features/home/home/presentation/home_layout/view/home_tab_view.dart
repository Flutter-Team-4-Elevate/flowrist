import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/config/notifications/notification_service.dart';
import 'package:flowrist/config/session/session_service.dart';
import 'package:flowrist/core/constants/app_images.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_cubit.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_event.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/cubit/home_cubit.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/cubit/home_event.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/cubit/home_state.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/view/widgets/home_header.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/view/widgets/home_section.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/view/widgets/home_shimmer.dart';
import 'package:flowrist/shared/addresses/presentation/view_model/addresses_event.dart';
import 'package:flowrist/shared/addresses/presentation/view_model/addresses_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTabView extends StatefulWidget {
  const HomeTabView({super.key, required this.pushNotificationsServices});

  final PushNotificationsServices pushNotificationsServices;

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeNotifications();
      _loadInitialData();
    });
  }

  // ============================================================
  // Notifications
  // ============================================================

  Future<void> _initializeNotifications() async {
    await widget.pushNotificationsServices.requestPermission();
    await widget.pushNotificationsServices.init();
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;

    // Load Home
    context.read<HomeCubit>().doEvent(GetHomeLayout());

    context.read<AddressesViewModel>().doEvent(InitializeAddress());

    // Load cart
    await _refreshCart();
  }

  // ============================================================
  // Pull To Refresh
  // ============================================================

  Future<void> _refreshHome() async {
    if (!mounted) return;

    // Refresh Home layout
    context.read<HomeCubit>().doEvent(GetHomeLayout());

    // Refresh cart
    await _refreshCart();

    // IMPORTANT:
    // Do NOT call InitializeAddress() here.
    //
    // The address state should remain untouched when the user
    // pulls to refresh.
  }

  // ============================================================
  // Cart
  // ============================================================

  Future<void> _refreshCart() async {
    final sessionService = getIt<SessionService>();

    final isGuest = await sessionService.isGuest();
    final token = await sessionService.getToken();

    if (!mounted) return;

    if (!isGuest && token.isNotEmpty) {
      await context.read<CartCubit>().doEvent(GetCartEvent());
    }
  }

  Future<void> _retry() async {
    await _refreshHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final homeState = state.homeLayout;

          if (homeState.isLoading) {
            return const HomeShimmer();
          }

          if (homeState.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    AppImages.noInternetConnection,
                    height: 220,
                    width: 220,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      homeState.errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: _retry,
                      child: const Text('Retry'),
                    ),
                  ),
                ],
              ),
            );
          }

          if (homeState.data == null || homeState.data!.isEmpty) {
            return Center(
              child: ElevatedButton(
                onPressed: _retry,
                child: const Text('Retry'),
              ),
            );
          }

          final sections = homeState.data!;

          return RefreshIndicator(
            onRefresh: _refreshHome,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: sections.length + 1,
              itemBuilder: (context, index) {
                // Home Header
                if (index == 0) {
                  return const HomeHeader();
                }

                // Home Sections
                final section = sections[index - 1];

                return HomeSection(section: section);
              },
            ),
          );
        },
      ),
    );
  }
}
