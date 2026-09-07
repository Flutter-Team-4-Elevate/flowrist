
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/features/checkout/presentation/view/widgets/delivery_address.dart';
import 'package:flowrist/features/checkout/presentation/view/widgets/delivery_time.dart';
import 'package:flowrist/features/checkout/presentation/view/widgets/gift_methods.dart';
import 'package:flowrist/features/checkout/presentation/view/widgets/payment_method.dart';
import 'package:flowrist/features/checkout/presentation/view/widgets/total_price.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_cubit.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_event.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({
    super.key,
    required this.cartId,
    required this.addressId,
    required this.subTotal,
  });

  final String cartId;
  final String addressId;
  final double subTotal;

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  @override
  void initState() {
    super.initState();

    _getDeliveryFee();

    context.read<CheckoutCubit>().doEvent(
          GetAddressesEvent(),
        );
  }

  void _getDeliveryFee() {
    context.read<CheckoutCubit>().doEvent(
          GetDeliveryFee(
            addressId: widget.addressId,
            cartId: widget.cartId,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: false,
              pinned: false,
              titleSpacing: 0,
              title: Text(localizations.checkout),
              leading: IconButton(
                onPressed: context.pop,
                icon: const Icon(Icons.arrow_back_ios),
              ),
            ),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  BlocConsumer<CheckoutCubit, CheckoutState>(
                    listenWhen: (previous, current) {
                      return previous.deliveryFeeState.errorMessage !=
                          current.deliveryFeeState.errorMessage;
                    },
                    listener: (context, state) {
                      final errorMessage =
                          state.deliveryFeeState.errorMessage;

                      if (errorMessage != null) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text(errorMessage),
                            ),
                          );
                      }
                    },
                    builder: (context, state) {
                      final deliveryFeeState =
                          state.deliveryFeeState;

                      final deliveryFee =
                          deliveryFeeState.data;

                      if (deliveryFeeState.isLoading) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      return DeliveryTime(
                        estimatedDeliveryAt:
                            deliveryFee?.estimatedDeliveryAt,
                      );
                    },
                  ),

                  const SizedBox(height: 25),

                  const _SectionDivider(),

                  const SizedBox(height: 25),

                  const DeliveryAddress(),

                  const SizedBox(height: 25),

                  const _SectionDivider(),

                  const SizedBox(height: 25),

                  const PaymentMethod(),

                  const SizedBox(height: 25),

                  const _SectionDivider(),

                  const SizedBox(height: 25),

                  GiftMethods(
                    onChanged: ({
                      required bool isGift,
                      required String name,
                      required String phone,
                    }) {
                      context.read<CheckoutCubit>().doEvent(
                            UpdateGiftInfo(
                              isGift: isGift,
                              name: name,
                              phone: phone,
                            ),
                          );
                    },
                  ),

                  const SizedBox(height: 25),

                  const _SectionDivider(),

                  const SizedBox(height: 25),

                  TotalPrice(
                    subTotal: widget.subTotal,
                    cartId: widget.cartId,
                    addressId: widget.addressId,
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: double.infinity,
      color: AppColors.white60,
    );
  }
}
 
