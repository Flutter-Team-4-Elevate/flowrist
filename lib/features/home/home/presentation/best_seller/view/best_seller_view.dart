import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_dimensions.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/ui/widgets/product_card.dart';
import 'package:flowrist/core/ui/widgets/products_shimmer.dart';
import 'package:flowrist/features/home/home/presentation/best_seller/cubit/best_seller_cubit.dart';
import 'package:flowrist/features/home/home/presentation/best_seller/cubit/best_seller_events.dart';
import 'package:flowrist/features/home/home/presentation/best_seller/cubit/best_seller_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BestSellerView extends StatefulWidget {
  const BestSellerView({super.key});

  @override
  State<BestSellerView> createState() => _BestSellerViewState();
}

class _BestSellerViewState extends State<BestSellerView> {
  static const String bestSellerCategoryId =
      '11111111-1111-1111-1111-000000000001';

  @override
  void initState() {
    super.initState();

    context.read<BestSellerCubit>().doEvent(
      GetBestSellerProductsEvent(bestSellerCategoryId),
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
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        title: Text(localizations.bestSeller),
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
        child: BlocBuilder<BestSellerCubit, BestSellerState>(
          builder: (context, state) {
            if (state.products.isLoading) {
              return const ProductsShimmer();
            }

            if (state.products.errorMessage != null) {
              return Center(child: Text(state.products.errorMessage!));
            }

            final products = state.products.data ?? [];

            if (products.isEmpty) {
              return Center(child: Text(localizations.noProductsFound));
            }

            return GridView.builder(
              padding: const EdgeInsets.all(AppDimensions.defaultScreenPadding),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                    context.push(AppRoutes.productDetailsPath(product.id));
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
    );
  }
}
