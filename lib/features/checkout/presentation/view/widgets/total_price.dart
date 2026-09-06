
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/endpoints.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/card_order_request_entity.dart';
import 'package:flowrist/features/checkout/domain/entities/payment_entity/gift_recipient_entity.dart';
import 'package:flowrist/features/checkout/presentation/view/success_order.dart';
import 'package:flowrist/features/checkout/presentation/view/widgets/sub_total.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_cubit.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_event.dart';
import 'package:flowrist/features/checkout/presentation/view_model/checkout_state.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_cubit.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_event.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

 

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
        // Listen only when placing the order finishes.
        //
        // This works for both:
        // - COD -> data == null
        // - Card -> data contains CardOrderEntity
        return previous.placeOrderState.isLoading &&
            !current.placeOrderState.isLoading;
      },
      listener: (context, state) async {
        final placeOrderState = state.placeOrderState;

        // ------------------------------------------------------------
        // ERROR
        // ------------------------------------------------------------
        if (placeOrderState.errorMessage != null) {
          if (!context.mounted) return;

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  placeOrderState.errorMessage!,
                ),
              ),
            );

          return;
        }

        // ------------------------------------------------------------
        // STILL LOADING
        // ------------------------------------------------------------
        if (placeOrderState.isLoading) {
          return;
        }

        // ------------------------------------------------------------
        // ORDER SUCCESS
        // ------------------------------------------------------------
        //
        // Important:
        // Your COD API returns:
        //
        // {
        //   "status": true,
        //   "code": 200,
        //   "message": "Order placed successfully.",
        //   "data": null
        // }
        //
        // So data == null DOES NOT mean the order failed.
        // It means the COD order was successfully created.
        // ------------------------------------------------------------

        final order = placeOrderState.data;

        // ------------------------------------------------------------
        // COD
        // ------------------------------------------------------------
        //
        // For COD, backend returns data: null.
        // Refresh the cart and navigate to success screen.
        // ------------------------------------------------------------
        if (order == null) {
          context.read<CartCubit>().doEvent(
                GetCartEvent(),
              );

          if (!context.mounted) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const SuccessOrder(),
            ),
          );

          return;
        }

        // ------------------------------------------------------------
        // CARD PAYMENT
        // ------------------------------------------------------------

        final sessionUrl = order.sessionUrl;

        // If there is no payment URL, consider the order completed.
        if (sessionUrl.isEmpty) {
          context.read<CartCubit>().doEvent(
                GetCartEvent(),
              );

          if (!context.mounted) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const SuccessOrder(),
            ),
          );

          return;
        }

        final uri = Uri.tryParse(sessionUrl);

        if (uri == null) {
          if (!context.mounted) return;

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  localizations.invalidpaymentURL,
                ),
              ),
            );

          return;
        }

        final success = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        if (!success) {
          if (!context.mounted) return;

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  localizations.couldnotopenpaymentpage,
                ),
              ),
            );
        }
      },
      builder: (context, state) {
        final deliveryFee =
            state.deliveryFeeState.data?.deliveryFee ?? 0.0;

        final total = subTotal + deliveryFee;

        final isLoading = state.placeOrderState.isLoading;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ------------------------------------------------------
              // SUBTOTAL
              // ------------------------------------------------------

              SubTotal(
                title: localizations.subTotal,
                price:
                    '${localizations.egp}${subTotal.toStringAsFixed(2)}',
              ),

              const SizedBox(height: 8),

              // ------------------------------------------------------
              // DELIVERY FEE
              // ------------------------------------------------------

              SubTotal(
                title: localizations.deliveryFee,
                price:
                    '${localizations.egp}${deliveryFee.toStringAsFixed(2)}',
              ),

              const Divider(
                height: 30,
                thickness: 1,
              ),

              // ------------------------------------------------------
              // TOTAL
              // ------------------------------------------------------

              SubTotal(
                title: localizations.total,
                price:
                    '${localizations.egp}${total.toStringAsFixed(2)}',
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 40),

              // ------------------------------------------------------
              // PLACE ORDER BUTTON
              // ------------------------------------------------------

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () => _placeOrder(context),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          localizations.placeOrder,
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==================================================================
  // PLACE ORDER
  // ==================================================================

  void _placeOrder(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final cubit = context.read<CheckoutCubit>();

    final state = cubit.state;

    final selectedPaymentMethod = state.selectedPaymentMethod;

    // ------------------------------------------------------------
    // PAYMENT METHOD VALIDATION
    // ------------------------------------------------------------

    if (selectedPaymentMethod == null) {
      _showMessage(
        context,
        localizations.pleaseselectapaymentmethod,
      );

      return;
    }

    // ------------------------------------------------------------
    // GIFT VALIDATION
    // ------------------------------------------------------------

    if (state.isGift) {
      if (state.giftName.trim().isEmpty) {
        _showMessage(
          context,
          localizations.pleaseenterrecipientname,
        );

        return;
      }

      if (state.giftPhone.trim().isEmpty) {
        _showMessage(
          context,
          localizations.pleaseenterrecipientphone,
        );

        return;
      }
    }

    // ------------------------------------------------------------
    // PAYMENT TYPE
    // ------------------------------------------------------------

    final isCard =
        selectedPaymentMethod == Endpoints.creditCard;

    // ------------------------------------------------------------
    // ORDER REQUEST
    // ------------------------------------------------------------

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
      paymentMethod: isCard
          ? Endpoints.card
          : Endpoints.cod,
      paymentGateway: isCard
          ? Endpoints.stripe
          : null,
    );

    // ------------------------------------------------------------
    // PLACE ORDER EVENT
    // ------------------------------------------------------------

    cubit.doEvent(
      PlaceOrder(
        order: request,
      ),
    );
  }

  // ==================================================================
  // SHOW MESSAGE
  // ==================================================================

  void _showMessage(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }
}