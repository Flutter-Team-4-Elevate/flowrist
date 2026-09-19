import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/ui/widgets/products_shimmer.dart';
import 'package:flowrist/features/home/search_and_filtering/search/presentation/cubit/search_cubit.dart';
import 'package:flowrist/features/home/search_and_filtering/search/presentation/cubit/search_state.dart';
import 'package:flowrist/features/home/search_and_filtering/search/presentation/view/widgets/search_empty_state.dart';
import 'package:flowrist/features/home/search_and_filtering/search/presentation/view/widgets/search_error_state.dart';
import 'package:flowrist/features/home/search_and_filtering/search/presentation/view/widgets/search_initial_state.dart';
import 'package:flowrist/features/home/search_and_filtering/search/presentation/view/widgets/search_input_field.dart';
import 'package:flowrist/features/home/search_and_filtering/search/presentation/view/widgets/search_products_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.sizeOf(context);
    final horizontalPadding = mediaQuery.width * 0.045;
    final topSpacing = mediaQuery.height * 0.018;
    final bodySpacing = mediaQuery.height * 0.022;

    return BlocProvider(
      create: (_) => getIt<SearchCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.whiteBase,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              children: [
                SizedBox(height: topSpacing),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.blackBase,
                        size: 20,
                      ),
                      onPressed: () => context.pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: SearchInputField(controller: _controller)),
                  ],
                ),
                SizedBox(height: bodySpacing),
                Expanded(child: _buildBody()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state.query.trim().isEmpty) {
          return const SearchInitialState();
        }
        if (state.results.isLoading) {
          return const ProductsShimmer();
        }
        if (state.results.errorMessage != null) {
          return SearchErrorState(errorMessage: state.results.errorMessage!);
        }

        final products = state.results.data ?? [];
        if (products.isEmpty) {
          return const SearchEmptyState();
        }

        return SearchProductsGrid(products: products);
      },
    );
  }
}
