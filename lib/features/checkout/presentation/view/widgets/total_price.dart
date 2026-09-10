import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/card_order_request_entity.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/gift_recipient_entity.dart';
import 'package:flowrist/features/checkout/presentation/view/payment_web_view.dart';
import 'package:flowrist/features/checkout/presentation/view/widgets/sub_total.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_cubit.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_event.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_state.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_cubit.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TotalPrice extends StatelessWidget {
  const TotalPrice({
    super.key,
    required this.cartId,
    required this.addressId,
    required this.subTotal,
  });

  final String cartId;
  final String addressId;
  final double subTotal;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocConsumer<CheckoutCubit, CheckoutState>(
      listenWhen: (previous, current) {
        return previous.placeOrderState.isLoading &&
            !current.placeOrderState.isLoading;
      },
      listener: (context, state) async {
        final placeOrderState = state.placeOrderState;

        if (placeOrderState.errorMessage != null) {
          if (!context.mounted) return;

          _showMessage(context, placeOrderState.errorMessage!);

          return;
        }

        final order = placeOrderState.data;

        // Cash on Delivery
        if (order == null) {
          await _handleOrderSuccess(context);
          return;
        }

        // Credit Card
        final sessionUrl = order.sessionUrl.trim();

        if (sessionUrl.isEmpty) {
          if (!context.mounted) return;

          _showMessage(context, localizations.invalidpaymentURL);

          return;
        }

        final uri = Uri.tryParse(sessionUrl);

        if (uri == null ||
            !uri.hasScheme ||
            (uri.scheme != 'http' && uri.scheme != 'https')) {
          if (!context.mounted) return;

          _showMessage(context, localizations.invalidpaymentURL);

          return;
        }

        final paymentResult = await context.push<bool>(
          AppRoutes.paymentWebView,
          extra: sessionUrl,
        );

        if (!context.mounted) return;

        if (paymentResult == true) {
          await _handleOrderSuccess(context);

          return;
        }
      },
      builder: (context, state) {
        final deliveryFee = state.deliveryFeeState.data?.deliveryFee ?? 0.0;

        final total = subTotal + deliveryFee;

        final isLoading = state.placeOrderState.isLoading;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SubTotal(
                title: localizations.subTotal,
                price: '${localizations.egp}${subTotal.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 8),
              SubTotal(
                title: localizations.deliveryFee,
                price: '${localizations.egp}${deliveryFee.toStringAsFixed(2)}',
              ),
              const Divider(height: 30, thickness: 1),
              SubTotal(
                title: localizations.total,
                price: '${localizations.egp}${total.toStringAsFixed(2)}',
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 40),

              // Only loading indicator in checkout.
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : () => _placeOrder(context),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(localizations.placeOrder),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleOrderSuccess(BuildContext context) async {
  final cartCubit = context.read<CartCubit>();

  await cartCubit.doEvent(GetCartEvent());

  if (!context.mounted) return;

  final cartState = cartCubit.state.cart;

  if (cartState.errorMessage != null) {
    _showMessage(context, cartState.errorMessage!);
    return;
  }

  // Cart was successfully cleared after placing the order.
  if (cartState.data == null || cartState.data!.items.isEmpty) {
    context.go(AppRoutes.successOrder);
    return;
  }

  // Unexpected case: order succeeded but cart is still not empty.
  _showMessage(
    context,
    'Order placed successfully, but cart could not be refreshed.',
  );
}

  void _placeOrder(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final cubit = context.read<CheckoutCubit>();

    final state = cubit.state;

    final selectedPaymentMethod = state.selectedPaymentMethod;

    if (selectedPaymentMethod == null) {
      _showMessage(context, localizations.pleaseselectapaymentmethod);

      return;
    }

    if (state.isGift) {
      if (state.giftName.trim().isEmpty) {
        _showMessage(context, localizations.pleaseenterrecipientname);

        return;
      }

      if (state.giftPhone.trim().isEmpty) {
        _showMessage(context, localizations.pleaseenterrecipientphone);

        return;
      }
    }

    final isCard = selectedPaymentMethod == Endpoints.creditCard;

    final request = CardOrderRequestEntity(
      cartId: cartId,
      addressId: addressId,
      isGift: state.isGift,
      giftRecipient: state.isGift
          ? GiftRecipientEntity(
              recipientName: state.giftName.trim(),
              recipientPhone: state.giftPhone.trim(),
            )
          : null,
      paymentMethod: isCard ? Endpoints.card : Endpoints.cod,
      paymentGateway: isCard ? Endpoints.stripe : null,
    );

    cubit.doEvent(PlaceOrder(order: request));
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
