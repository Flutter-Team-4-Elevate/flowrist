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
  const HomeTabView({super.key});

  @override
  State<HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeNotifications();
    });
    _loadHome();
  }

  Future<void> _initializeNotifications() async {
    final pushNotifications = getIt<PushNotificationsServices>();

    await pushNotifications.requestPermission();
    await pushNotifications.init();
  }

  Future<void> _loadHome() async {
    if (!mounted) return;

    // Refresh home layout
    context.read<HomeCubit>().doEvent(GetHomeLayout());

    context.read<AddressesViewModel>().doEvent(InitializeAddress());

    // Refresh cart for logged-in user
    final sessionService = getIt<SessionService>();

    final isGuest = await sessionService.isGuest();
    final token = await sessionService.getToken();

    if (!mounted) return;

    if (!isGuest && token.isNotEmpty) {
      context.read<CartCubit>().doEvent(GetCartEvent());
    }
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
                  Center(
                    child: Text(
                      homeState.errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: _loadHome,
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
                onPressed: _loadHome,
                child: const Text('Retry'),
              ),
            );
          }

          final sections = homeState.data!;

          return RefreshIndicator(
            onRefresh: _loadHome,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: sections.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const HomeHeader();
                }

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
