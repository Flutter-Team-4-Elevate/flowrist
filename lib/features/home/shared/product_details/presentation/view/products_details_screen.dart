import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/features/home/shared/product_details/data/models/product_details_request_dto.dart';
import 'package:flowrist/features/home/shared/product_details/presentation/view/product_details_shimmer.dart';
import 'package:flowrist/features/home/shared/product_details/presentation/view_model/product_details_event/product_details_event.dart';
import 'package:flowrist/features/home/shared/product_details/presentation/view_model/product_details_view_model/product_details_view_model.dart';
import 'package:flowrist/features/home/shared/product_details/presentation/widgets/product_bottom_bar.dart';
import 'package:flowrist/features/home/shared/product_details/presentation/widgets/product_image_sliver_app_bar.dart';
import 'package:flowrist/features/home/shared/product_details/presentation/widgets/product_info_sections.dart';
import 'package:flowrist/features/home/shared/product_details/presentation/widgets/product_price_and_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ProductDetailsViewModel>()
            ..add(GetProductDetailsEvent(productId)),
      child: _ProductDetailsView(productId: productId),
    );
  }
}

class _ProductDetailsView extends StatelessWidget {
  final String productId;

  const _ProductDetailsView({required this.productId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<
      ProductDetailsViewModel,
      BaseState<ProductDetailsRequestDto>
    >(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(body: ProductDetailsShimmer());
        }

        if (state.errorMessage != null) {
          return Scaffold(
            appBar: _buildSimpleAppBar(context),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: AppColors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.errorMessage!,
                      textAlign: TextAlign.center,
                      style: AppStyles.regular14Inter,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProductDetailsViewModel>().add(
                          GetProductDetailsEvent(productId),
                        );
                      },
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final product = state.data;
        if (product == null) {
          return Scaffold(
            appBar: _buildSimpleAppBar(context),
            body: Center(
              child: Text(
                l10n.noProductsFound,
                style: AppStyles.regular14Inter,
              ),
            ),
          );
        }

        return _ProductDetailsContent(product: product);
      },
    );
  }

  PreferredSizeWidget _buildSimpleAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.blackBase,
          size: 20,
        ),
        onPressed: () => context.pop(),
      ),
    );
  }
}

class _ProductDetailsContent extends StatefulWidget {
  final ProductDetailsRequestDto product;

  const _ProductDetailsContent({required this.product});

  @override
  State<_ProductDetailsContent> createState() => _ProductDetailsContentState();
}

class _ProductDetailsContentState extends State<_ProductDetailsContent> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final expandedHeight = screenWidth * 1.15;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: ProductBottomBar(product: widget.product),
      body: CustomScrollView(
        slivers: [
          ProductImageSliverAppBar(
            images: widget.product.images,
            expandedHeight: expandedHeight,
            pageController: _pageController,
            currentImageIndex: _currentImageIndex,
            onPageChanged: (index) =>
                setState(() => _currentImageIndex = index),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductPriceAndStatus(product: widget.product),
                  const SizedBox(height: 16),
                  Text(
                    widget.product.name,
                    style: AppStyles.medium16InterBlack,
                  ),
                  const SizedBox(height: 24),
                  ProductDescriptionSection(
                    description: widget.product.description,
                  ),
                  if (widget.product.availableStock > 0) ...[
                    const SizedBox(height: 8),
                    Text(
                      '${l10n.productAvailableStock}: ${widget.product.availableStock} ${l10n.items}',
                      style: AppStyles.regular13W500.copyWith(
                        color: AppColors.grey30,
                      ),
                    ),
                  ],
                  if (widget.product.includes.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    ProductIncludesSection(includes: widget.product.includes),
                  ],
                  SizedBox(height: mediaQuery.padding.bottom + 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
