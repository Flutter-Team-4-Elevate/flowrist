import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/config/session/session_service.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_cubit.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_event.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/cubit/home_cubit.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/cubit/home_event.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/cubit/home_state.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/view/widgets/home_header.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/view/widgets/home_section.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/view/widgets/home_shimmer.dart';
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
    _checkAndFetchCart();
  }

  Future<void> _checkAndFetchCart() async {
    final sessionService = getIt<SessionService>();
    final isGuest = await sessionService.isGuest();
    final token = await sessionService.getToken();

    if (!isGuest && token.isNotEmpty && mounted) {
      context.read<CartCubit>().doEvent(GetCartEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..doEvent(GetHomeLayout()),
      child: Scaffold(
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final homeState = state.homeLayout;

            if (homeState.isLoading) {
              return const HomeShimmer();
            }

            if (homeState.errorMessage != null) {
              return Center(child: Text(homeState.errorMessage!));
            }

            if (homeState.data == null || homeState.data!.isEmpty) {
              return const Center(child: Text('No content available'));
            }

            final sections = homeState.data!;

            return ListView.builder(
              itemCount: sections.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const HomeHeader();
                }

                final section = sections[index - 1];

                return HomeSection(section: section);
              },
            );
          },
        ),
      ),
    );
  }
}
