import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/config/session/session_guard.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_cubit.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_event.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_state.dart';
import 'package:flowrist/features/home/cart/presentation/helpers/pending_cart_action_store.dart';
import 'package:flowrist/features/home/shared/product_details/data/models/product_details_request_dto.dart';
import 'package:flowrist/features/home/shared/product_details/presentation/view/product_details_shimmer.dart';
import 'package:flowrist/features/home/shared/product_details/presentation/view_model/product_details_event/product_details_event.dart';
import 'package:flowrist/features/home/shared/product_details/presentation/view_model/product_details_view_model/product_details_view_model.dart';
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
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                onPressed: () => context.pop(),
              ),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(state.errorMessage!, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProductDetailsViewModel>().add(
                          GetProductDetailsEvent(productId),
                        );
                      },
                      child: const Text('Retry'),
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
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                onPressed: () => context.pop(),
              ),
            ),
            body: const Center(child: Text('Product not found')),
          );
        }

        return _ProductDetailsBody(product: product);
      },
    );
  }
}

class _ProductDetailsBody extends StatefulWidget {
  final ProductDetailsRequestDto product;

  const _ProductDetailsBody({required this.product});

  @override
  State<_ProductDetailsBody> createState() => _ProductDetailsBodyState();
}

class _ProductDetailsBodyState extends State<_ProductDetailsBody> {
  static const double _expandedHeight = 460;
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final images = product.images;

    return Scaffold(
      backgroundColor: Colors.white,

      // ==========================================
      // ADD TO CART / QUANTITY CONTROLLER
      // ==========================================
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: SizedBox(
            height: 52,
            child: BlocBuilder<CartCubit, CartState>(
              buildWhen: (previous, current) =>
                  previous.getQuantity(product.id) !=
                      current.getQuantity(product.id) ||
                  previous.isProductLoading(product.id) !=
                      current.isProductLoading(product.id),
              builder: (context, cartState) {
                final isAdding = cartState.isProductLoading(product.id);
                final quantity = cartState.getQuantity(product.id);

                if (!product.inStock) {
                  return ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Out of stock',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  );
                }

                if (quantity == 0) {
                  return ElevatedButton(
                    onPressed: isAdding
                        ? null
                        : () async {
                            final event = AddToCartEvent(productId: product.id);

                            final canContinue = await checkGuestMode(context);
                            if (!canContinue) {
                              getIt<PendingCartActionStore>().setPendingAction(
                                event,
                              );
                              return;
                            }

                            if (!context.mounted) return;
                            context.read<CartCubit>().doIntent(event);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCE1567),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      elevation: 0,
                    ),
                    child: isAdding
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Add to cart',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  );
                }

                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFCE1567),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, color: Colors.white),
                        onPressed: () {
                          context.read<CartCubit>().doIntent(
                            ChangeCartQuantityEvent(
                              productId: product.id,
                              delta: -1,
                            ),
                          );
                        },
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) =>
                            ScaleTransition(scale: animation, child: child),
                        child: Text(
                          '$quantity in cart',
                          key: ValueKey<int>(quantity),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          if (quantity >= product.availableStock) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Reached max available stock'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                            return;
                          }
                          context.read<CartCubit>().doIntent(
                            ChangeCartQuantityEvent(
                              productId: product.id,
                              delta: 1,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),

      // ==========================================
      // BODY
      // ==========================================
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: _expandedHeight,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFFF9F9F9),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
                size: 20,
              ),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final top = constraints.biggest.height;
                final delta = top - kToolbarHeight;
                final totalExpand = _expandedHeight - kToolbarHeight;
                final expandRatio = (delta / totalExpand).clamp(0.0, 1.0);

                return FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (images.isEmpty)
                        Container(
                          color: const Color(0xFFF5F5F5),
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      else
                        Transform.scale(
                          scale: 0.85 + (0.15 * expandRatio),
                          child: Opacity(
                            opacity: expandRatio,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: images.length,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentImageIndex = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                return Image.network(
                                  images[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (_, _, _) {
                                    return Container(
                                      color: const Color(0xFFF5F5F5),
                                      child: const Center(
                                        child: Icon(
                                          Icons.image_not_supported_outlined,
                                          size: 60,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      if (images.length > 1 && expandRatio > 0.2)
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(images.length, (index) {
                              final isSelected = _currentImageIndex == index;

                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: isSelected ? 20 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: isSelected
                                      ? const Color(0xFFCE1567)
                                      : Colors.grey.shade400.withValues(
                                          alpha: 0.7,
                                        ),
                                ),
                              );
                            }),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'EGP ${(product.discountedPrice ?? product.price).toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF111111),
                                ),
                              ),
                              if (product.discountedPrice != null &&
                                  product.discountedPrice! < product.price) ...[
                                const SizedBox(width: 8),
                                Text(
                                  'EGP ${product.price.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade400,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'All prices include tax',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Status: ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111111),
                            ),
                          ),
                          Text(
                            product.inStock ? 'In stock' : 'Out of stock',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: product.inStock
                                  ? Colors.grey.shade700
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111111),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111111),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description.isNotEmpty
                        ? product.description
                        : 'No description available for this product.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  if (product.availableStock > 0) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Available: ${product.availableStock} items',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  if (product.includes.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Bouquet include',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111111),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...product.includes.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      );
                    }),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
