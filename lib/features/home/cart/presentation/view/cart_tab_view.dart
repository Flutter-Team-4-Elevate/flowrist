import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/ui/widgets/app_button.dart';
import 'package:flowrist/core/ui/widgets/cart_item_card.dart';
import 'package:flowrist/features/home/cart/domain/entities/cart_item_entity.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_cubit.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_event.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_state.dart';
import 'package:flowrist/shared/addresses/presentation/view_model/addresses_state.dart';
import 'package:flowrist/shared/addresses/presentation/view_model/addresses_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartTabView extends StatefulWidget {
  const CartTabView({super.key});

  @override
  State<CartTabView> createState() => _CartTabViewState();
}

class _CartTabViewState extends State<CartTabView> {
  @override
  void initState() {
    super.initState();

    context.read<CartCubit>().doEvent(GetCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: BlocBuilder<CartCubit, CartState>(
          buildWhen: (previous, current) {
            return previous.cart.data?.totalQuantity !=
                current.cart.data?.totalQuantity;
          },
          builder: (context, state) {
            final cart = state.cart.data;
            final itemCount = cart?.totalQuantity ?? 0;

            return Text(
              '${localization.cart} ($itemCount ${localization.items})',
            );
          },
        ),
      ),

      body: SafeArea(
        child: BlocBuilder<CartCubit, CartState>(
          buildWhen: (previous, current) {
            return previous.cart.isLoading != current.cart.isLoading ||
                previous.cart.errorMessage != current.cart.errorMessage ||
                previous.cart.data?.items.length !=
                    current.cart.data?.items.length;
          },
          builder: (context, state) {
            if (state.cart.isLoading && state.cart.data == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.cart.errorMessage != null && state.cart.data == null) {
              return Center(
                child: Text(
                  state.cart.errorMessage!,
                  style: AppStyles.regular14Inter,
                ),
              );
            }

            final cart = state.cart.data;

            if (cart == null || cart.items.isEmpty) {
              return Center(child: Text(localization.yourCartIsEmpty));
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined),
                      const SizedBox(width: 4),
                      BlocBuilder<AddressesViewModel, AddressesState>(
                        builder: (context, state) {
                          final selectedAddress = state.selectedAddress;
                          return Expanded(
                            child: Text(
                              '${localization.deliverTo} '
                              '${selectedAddress?.area}-${selectedAddress?.addressLine}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.medium18Inter.copyWith(
                                fontSize: 14,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final itemId = cart.items[index].itemId;

                      return BlocBuilder<CartCubit, CartState>(
                        buildWhen: (previous, current) {
                          final previousCart = previous.cart.data;
                          final currentCart = current.cart.data;

                          if (previousCart == null || currentCart == null) {
                            return true;
                          }

                          final previousIndex = previousCart.items.indexWhere(
                            (item) => item.itemId == itemId,
                          );
                          final currentIndex = currentCart.items.indexWhere(
                            (item) => item.itemId == itemId,
                          );

                          if (previousIndex == -1 || currentIndex == -1) {
                            return true;
                          }

                          final previousItem =
                              previousCart.items[previousIndex];
                          final currentItem = currentCart.items[currentIndex];
                          final previousIsLoading = previous.loadingItemIds
                              .contains(itemId);
                          final currentIsLoading = current.loadingItemIds
                              .contains(itemId);

                          return previousItem.quantity !=
                                  currentItem.quantity ||
                              previousIsLoading != currentIsLoading;
                        },
                        builder: (context, state) {
                          final cart = state.cart.data;

                          if (cart == null) {
                            return const SizedBox.shrink();
                          }

                          final itemIndex = cart.items.indexWhere(
                            (item) => item.itemId == itemId,
                          );

                          if (itemIndex == -1) {
                            return const SizedBox.shrink();
                          }

                          final CartItemEntity item = cart.items[itemIndex];
                          final isLoading = state.loadingItemIds.contains(
                            item.itemId,
                          );

                          return CartItemCard(
                            item: item,
                            isLoading: isLoading,

                            onDelete: () {
                              context.read<CartCubit>().doEvent(
                                RemoveCartItemEvent(itemId: item.itemId),
                              );
                            },

                            onIncrease: () {
                              if (item.quantity < item.availableStock) {
                                context.read<CartCubit>().doEvent(
                                  ChangeCartQuantityEvent(
                                    itemId: item.itemId,
                                    quantity: item.quantity + 1,
                                  ),
                                );
                              }
                            },

                            onDecrease: () {
                              context.read<CartCubit>().doEvent(
                                ChangeCartQuantityEvent(
                                  itemId: item.itemId,
                                  quantity: item.quantity - 1,
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    separatorBuilder: (_, _) {
                      return const SizedBox(height: 25);
                    },
                  ),

                  const SizedBox(height: 30),

                  BlocBuilder<CartCubit, CartState>(
                    buildWhen: (previous, current) {
                      final previousCart = previous.cart.data;
                      final currentCart = current.cart.data;

                      return previousCart?.subtotal != currentCart?.subtotal ||
                          previousCart?.deliveryFee !=
                              currentCart?.deliveryFee ||
                          previousCart?.total != currentCart?.total;
                    },
                    builder: (context, state) {
                      final cart = state.cart.data;

                      if (cart == null) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                localization.subTotal,
                                style: AppStyles.medium16Roboto,
                              ),
                              const Spacer(),
                              Text(
                                '${localization.egp} ${cart.subtotal}',
                                style: AppStyles.regular14Inter,
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Text(
                                localization.deliveryFee,
                                style: AppStyles.medium16Roboto,
                              ),
                              const Spacer(),
                              Text(
                                '${localization.egp} ${cart.deliveryFee}',
                                style: AppStyles.regular14Inter,
                              ),
                            ],
                          ),

                          const Divider(
                            color: AppColors.white70,
                            thickness: 0.5,
                          ),

                          Row(
                            children: [
                              Text(
                                localization.total,
                                style: AppStyles.medium18Inter,
                              ),
                              const Spacer(),
                              Text(
                                '${localization.egp} ${cart.total}',
                                style: AppStyles.medium18Inter,
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  AppButton(text: localization.checkout, onPressed: () {}),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
