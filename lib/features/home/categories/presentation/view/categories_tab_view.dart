import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_dimensions.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/ui/widgets/app_search_bar.dart';
import 'package:flowrist/core/ui/widgets/filter_button.dart';
import 'package:flowrist/core/ui/widgets/product_card.dart';
import 'package:flowrist/core/ui/widgets/products_shimmer.dart';
import 'package:flowrist/core/ui/widgets/selection_bar.dart';
import 'package:flowrist/core/ui/widgets/selection_shimmer.dart';
import 'package:flowrist/features/home/categories/presentation/cubit/categories_cubit.dart';
import 'package:flowrist/features/home/categories/presentation/cubit/categories_events.dart';
import 'package:flowrist/features/home/categories/presentation/cubit/categories_state.dart';
import 'package:flowrist/features/home/search_and_filtering/filter/presentation/widgets/filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CategoriesTabView extends StatelessWidget {
  const CategoriesTabView({super.key});

  void _openFilter(BuildContext context) async {
    final cubit = context.read<CategoriesCubit>();
    final selected = await FilterBottomSheet.show(
      context,
      currentSelection: cubit.state.selectedSort,
    );
    if (selected != cubit.state.selectedSort) {
      cubit.doEvent(ApplySortEvent(selected));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBase,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.purpleBase,
        foregroundColor: AppColors.white,
        elevation: 4,
        shape: const StadiumBorder(),
        onPressed: () => _openFilter(context),
        icon: const Icon(Icons.tune, size: 20),
        label: Text(
          AppLocalizations.of(context)!.filter,
          style: AppStyles.medium16Inter,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.defaultScreenPadding,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: AppSearchBar(
                      readOnly: true,
                      onTap: () {
                        context.push(AppRoutes.search);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: BlocSelector<CategoriesCubit, CategoriesState, bool>(
                      selector: (state) => state.selectedSort != null,
                      builder: (context, isFilterActive) {
                        return FilterButton(
                          isSelected: isFilterActive,
                          onPressed: () => _openFilter(context),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<CategoriesCubit, CategoriesState>(
              buildWhen: (previous, current) =>
                  previous.categories != current.categories ||
                  previous.selectedIndex != current.selectedIndex,
              builder: (context, state) {
                if (state.categories.isLoading) {
                  return const SelectionShimmer();
                }

                final categories = state.categories.data ?? [];
                return SelectionBar(
                  items: categories.map((category) => category.name).toList(),
                  selectedIndex: state.selectedIndex,
                  onItemSelected: (index) {
                    context.read<CategoriesCubit>().doEvent(
                      SelectCategoryEvent(index),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 25),
            Expanded(
              child: BlocBuilder<CategoriesCubit, CategoriesState>(
                buildWhen: (previous, current) =>
                    previous.products != current.products,
                builder: (context, state) {
                  if (state.products.isLoading) {
                    return const ProductsShimmer();
                  }

                  final products = state.products.data ?? [];
                  if (products.isEmpty) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!.noProductsFound,
                        style: AppStyles.regular14Inter,
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.defaultScreenPadding,
                      AppDimensions.defaultScreenPadding,
                      AppDimensions.defaultScreenPadding,
                      80,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.60,
                        ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () {
                          context.push(
                            AppRoutes.productDetailsPath(product.id),
                          );
                        },
                        child: ProductCard(
                          productId: product.id,
                          title: product.name,
                          price: product.price.toString(),
                          oldPrice: product.discountPrice?.toString() ?? '',
                          discount: product.discountPercentage != null
                              ? '${product.discountPercentage!.toInt()}%'
                              : '',
                          image: product.imageUrl,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
