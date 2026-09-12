import 'package:cached_network_image/cached_network_image.dart';
import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/config/session/session_guard.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_images.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_cubit.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_event.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_state.dart';
import 'package:flowrist/features/home/cart/presentation/helpers/pending_cart_action_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCard extends StatelessWidget {
  final String productId;
  final String title;
  final String price;
  final String oldPrice;
  final String discount;
  final String image;

  const ProductCard({
    super.key,
    required this.productId,
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.whiteBase,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.white70, width: 0.5),
      ),
      child: Column(
        children: [
          _buildProductImage(),

          const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: AppStyles.regular13,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Text(
                '${AppLocalizations.of(context)!.egp} $price',
                style: AppStyles.regular14InterW500,
              ),

              const SizedBox(width: 6),

              if (oldPrice.isNotEmpty)
                Text(
                  oldPrice,
                  style: AppStyles.regular14Inter.copyWith(
                    decoration: TextDecoration.lineThrough,
                  ),
                ),

              const SizedBox(width: 6),

              if (discount.isNotEmpty)
                Text(
                  discount,
                  style: AppStyles.regular14Inter.copyWith(
                    color: AppColors.green,
                  ),
                ),
            ],
          ),

          const Spacer(),

          _buildAddToCartSection(context),
        ],
      ),
    );
  }

  Widget _buildAddToCartSection(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      buildWhen: (previous, current) {
        return previous.getQuantity(productId) !=
                current.getQuantity(productId) ||
            previous.isProductAdding(productId) !=
                current.isProductAdding(productId) ||
            previous.isProductLoading(productId) !=
                current.isProductLoading(productId);
      },
      builder: (context, state) {
        final quantity = state.getQuantity(productId);

        final isAdding = state.isProductAdding(productId);

        final isUpdating = state.isProductLoading(productId);

        final cartItem = state.getCartItem(productId);

        if (quantity == 0) {
          return SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: AppStyles.regular13W500,
              ),
              onPressed: isAdding
                  ? null
                  : () async {
                      final event = AddToCartEvent(productId: productId);

                      final canContinue = await checkGuestMode(context);

                      if (!canContinue) {
                        getIt<PendingCartActionStore>().setPendingAction(event);
                        return;
                      }

                      if (!context.mounted) return;

                      context.read<CartCubit>().doEvent(event);
                    },
              child: isAdding
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_cart_outlined, size: 18),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context)!.addToCart),
                      ],
                    ),
            ),
          );
        }

        if (cartItem == null) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 38,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 18),
                onPressed: isUpdating
                    ? null
                    : () {
                        context.read<CartCubit>().doEvent(
                          ChangeCartQuantityEvent(
                            itemId: cartItem.itemId,
                            quantity: quantity - 1,
                          ),
                        );
                      },
              ),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: isUpdating
                    ? const SizedBox(
                        key: ValueKey('loading'),
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        '$quantity',
                        key: ValueKey<int>(quantity),
                        style: AppStyles.regular14InterW500,
                      ),
              ),

              IconButton(
                icon: const Icon(Icons.add, size: 18),
                onPressed: isUpdating || quantity >= cartItem.availableStock
                    ? null
                    : () {
                        context.read<CartCubit>().doEvent(
                          ChangeCartQuantityEvent(
                            itemId: cartItem.itemId,
                            quantity: quantity + 1,
                          ),
                        );
                      },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductImage() {
    if (image.isEmpty) {
      return Image.asset(
        AppImages.cardDefultImage,
        width: double.infinity,
        height: 150,
        fit: BoxFit.cover,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: image,
        width: double.infinity,
        height: 150,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) {
          return Image.asset(
            AppImages.cardDefultImage,
            width: double.infinity,
            height: 150,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
