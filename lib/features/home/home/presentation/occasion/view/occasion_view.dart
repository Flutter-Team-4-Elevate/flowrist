import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_dimensions.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/ui/widgets/products_shimmer.dart';
import 'package:flowrist/core/ui/widgets/selection_shimmer.dart';
import 'package:flowrist/core/ui/widgets/product_card.dart';
import 'package:flowrist/core/ui/widgets/selection_bar.dart';
import 'package:flowrist/features/home/home/presentation/occasion/cubit/occasion_cubit.dart';
import 'package:flowrist/features/home/home/presentation/occasion/cubit/occasion_state.dart';
import 'package:flowrist/features/home/home/presentation/occasion/cubit/occassion_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OccasionView extends StatefulWidget {
  const OccasionView({super.key, this.occasionId, required this.initialIndex});

  final String? occasionId;
  final int initialIndex;

  @override
  State<OccasionView> createState() => _OccasionViewState();
}

class _OccasionViewState extends State<OccasionView> {
  @override
  void initState() {
    super.initState();

    context.read<OccasionCubit>().doEvent(
      GetOccasionsEvent(
        targetOccasionId: widget.occasionId,
        initialIndex: widget.initialIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: AppDimensions.defaultScreenPadding,
          ),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        title: Text(localizations.occasion),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(24),
          child: Padding(
            padding: const EdgeInsets.only(left: 55, bottom: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                localizations.bestSellerSubtitle,
                style: AppStyles.regular13W500,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<OccasionCubit, OccasionState>(
          builder: (context, state) {
            final products = state.products.data ?? [];
            final occasions = state.occasions.data ?? [];

            return Column(
              children: [
                const SizedBox(height: 10),

                if (state.occasions.isLoading)
                  const SelectionShimmer()
                else if (occasions.isNotEmpty)
                  SelectionBar(
                    items: (state.occasions.data ?? [])
                        .map((occasion) => occasion.name)
                        .toList(),
                    selectedIndex: state.selectedIndex,
                    onItemSelected: (index) {
                      context.read<OccasionCubit>().doEvent(
                        SelectOccasionEvent(index),
                      );
                    },
                  ),

                const SizedBox(height: 25),

                Expanded(
                  child: state.products.isLoading
                      ? const ProductsShimmer()
                      : products.isEmpty
                      ? Center(child: Text(localizations.noProductsFound))
                      : GridView.builder(
                          padding: const EdgeInsets.all(
                            AppDimensions.defaultScreenPadding,
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
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
