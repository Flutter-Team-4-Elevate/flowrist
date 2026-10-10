import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/config/session/session_guard.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_item_entity.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_cubit.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_event.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_state.dart';
import 'package:flowrist/features/home/cart/presentation/helpers/pending_cart_action_store.dart';
import 'package:flowrist/features/home/shared/product_details/data/models/product_details_request_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBottomBar extends StatelessWidget {
  final ProductDetailsRequestDto product;

  const ProductBottomBar({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: 12,
        ),
        child: SizedBox(
          height: 52,
          child: BlocBuilder<CartCubit, CartState>(
            buildWhen: (prev, curr) =>
                prev.getQuantity(product.id) != curr.getQuantity(product.id) ||
                prev.isProductLoading(product.id) !=
                    curr.isProductLoading(product.id) ||
                prev.isProductAdding(product.id) !=
                    curr.isProductAdding(product.id),
            builder: (context, cartState) {
              final cartItems = cartState.cart.data?.items ?? [];
              final cartItem = cartItems.cast<CartItemEntity?>().firstWhere(
                (item) => item?.productId == product.id,
                orElse: () => null,
              );

              final quantity = cartItem?.quantity ?? 0;
              final isAdding =
                  cartState.addingProductIds.contains(product.id) ||
                  (cartItem != null &&
                      cartState.loadingItemIds.contains(cartItem.itemId));

              if (!product.inStock) {
                return ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: AppColors.white60,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.productOutOfStock,
                    style: AppStyles.medium16Inter.copyWith(
                      color: AppColors.whiteBase,
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
                          context.read<CartCubit>().doEvent(event);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purpleBase,
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
                              AppColors.white,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.shopping_cart_outlined,
                              color: AppColors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.addToCart,
                              style: AppStyles.medium16Inter,
                            ),
                          ],
                        ),
                );
              }

              return Container(
                decoration: BoxDecoration(
                  color: AppColors.purpleBase,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, color: AppColors.white),
                      onPressed: () {
                        if (cartItem == null) return;
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
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: Text(
                        '$quantity ${l10n.cart}',
                        key: ValueKey<int>(quantity),
                        style: AppStyles.medium16Inter,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: AppColors.white),
                      onPressed: () {
                        if (cartItem == null) return;
                        if (quantity >= product.availableStock) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${l10n.productAvailableStock}: ${product.availableStock}',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                          return;
                        }
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
          ),
        ),
      ),
    );
  }
}
