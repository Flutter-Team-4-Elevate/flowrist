import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/card_order_request_entity.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/gift_recipient_entity.dart';
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

        // =========================================================
        // 1. API / REPOSITORY ERROR
        // =========================================================

        if (placeOrderState.errorMessage != null) {
          if (!context.mounted) return;

          _showMessage(context, placeOrderState.errorMessage!);

          return;
        }

        // =========================================================
        // 2. CASH ON DELIVERY
        // =========================================================
        //
        // IMPORTANT:
        // COD does NOT need sessionUrl.
        //
        // Backend response:
        //
        // {
        //   "orderId": "...",
        //   "orderNumber": "...",
        //   "status": "PLACED",
        //   "paymentStatus": "PENDING",
        //   "paymentMethod": "COD",
        //   "subtotal": 33.98,
        //   "deliveryFee": 25.0,
        //   "total": 58.98
        // }
        //
        // Therefore we handle COD before checking sessionUrl.
        // =========================================================

        final isCash = state.selectedPaymentMethod == Endpoints.cash;

        if (isCash) {
          await _handleOrderSuccess(context);
          return;
        }

        // =========================================================
        // 3. CREDIT CARD
        // =========================================================

        final order = placeOrderState.data;

        if (order == null) {
          if (!context.mounted) return;

          _showMessage(context, 'Invalid card order response.');

          return;
        }

        final sessionUrl = order.sessionUrl;

        if (sessionUrl == null || sessionUrl.trim().isEmpty) {
          if (!context.mounted) return;

          _showMessage(context, 'Payment session URL is missing.');

          return;
        }

        // =========================================================
        // 4. OPEN PAYMENT WEBVIEW
        // =========================================================

        final paymentResult = await context.push<bool>(
          AppRoutes.paymentWebView,
          extra: sessionUrl,
        );

        if (!context.mounted) return;

        // =========================================================
        // 5. PAYMENT SUCCESS
        // =========================================================

        if (paymentResult == true) {
          await _handleOrderSuccess(context);
          return;
        }

        // =========================================================
        // 6. PAYMENT FAILED / CANCELLED
        // =========================================================

        _showMessage(context, 'Payment failed. Please try again.');
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

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : () => _placeOrder(context),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
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

    // Refresh cart after successful order.
    await cartCubit.doEvent(GetCartEvent());

    if (!context.mounted) return;

    final cartState = cartCubit.state.cart;

    // =========================================================
    // CART IS EMPTY
    // =========================================================
    //
    // After successful order your API returns:
    //
    // items: []
    //
    // Therefore go directly to success screen.
    // =========================================================

    if (cartState.data != null && cartState.data!.items.isEmpty) {
      context.go(AppRoutes.successOrder);

      return;
    }

    // =========================================================
    // CART DATA IS NULL
    // =========================================================

    if (cartState.data == null) {
      _showMessage(
        context,
        'Order placed successfully, but the cart could not be refreshed.',
      );

      return;
    }

    // =========================================================
    // CART STILL HAS ITEMS
    // =========================================================

    _showMessage(
      context,
      'Order placed successfully, but the cart is not empty.',
    );
  }

  void _placeOrder(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final cubit = context.read<CheckoutCubit>();
    final state = cubit.state;

    final selectedPaymentMethod = state.selectedPaymentMethod;

    // =========================================================
    // PAYMENT METHOD REQUIRED
    // =========================================================

    if (selectedPaymentMethod == null) {
      _showMessage(context, localizations.pleaseselectapaymentmethod);

      return;
    }

    // =========================================================
    // PAYMENT TYPE
    // =========================================================

    final isCard = selectedPaymentMethod == Endpoints.creditCard;

    // =========================================================
    // GIFT
    // =========================================================
    //
    // Gift is ONLY allowed with credit card.
    //
    // Even if state.isGift somehow remains true,
    // COD will send isGift=false.
    // =========================================================

    final isGift = isCard && state.isGift;

    // =========================================================
    // VALIDATE GIFT
    // =========================================================

    if (isGift) {
      if (state.giftName.trim().isEmpty) {
        _showMessage(context, localizations.pleaseenterrecipientname);

        return;
      }

      if (state.giftPhone.trim().isEmpty) {
        _showMessage(context, localizations.pleaseenterrecipientphone);

        return;
      }
    }

    // =========================================================
    // REQUEST
    // =========================================================

    final request = CardOrderRequestEntity(
      cartId: cartId,
      addressId: addressId,

      // COD => false
      // Card + gift => true
      isGift: isGift,

      giftRecipient: isGift
          ? GiftRecipientEntity(
              recipientName: state.giftName.trim(),
              recipientPhone: state.giftPhone.trim(),
            )
          : null,

      paymentMethod: isCard ? Endpoints.card : Endpoints.cod,

      paymentGateway: isCard ? Endpoints.stripe : null,
    );

    // =========================================================
    // DEBUG
    // =========================================================

    debugPrint('========== PLACE ORDER ==========');
    debugPrint('cartId: ${request.cartId}');
    debugPrint('addressId: ${request.addressId}');
    debugPrint('paymentMethod: ${request.paymentMethod}');
    debugPrint('paymentGateway: ${request.paymentGateway}');
    debugPrint('isGift: ${request.isGift}');
    debugPrint('giftRecipient: ${request.giftRecipient}');
    debugPrint('=================================');

    // =========================================================
    // PLACE ORDER
    // =========================================================

    cubit.doEvent(PlaceOrder(order: request));
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
