import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_dimensions.dart';
import 'package:flowrist/core/constants/app_images.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/ui/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TrackingView extends StatelessWidget {
  final String orderId;
  const TrackingView({super.key, required this.orderId});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.go(AppRoutes.homeTab);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(l10n.trackOrder),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.defaultScreenPadding),
          child: Column(
            children: [
              SizedBox(height: 20),
              SizedBox(
                height: 170,
                width: 170,
                child: Image.asset(AppImages.flowerTrackingOrder),
              ),
              const SizedBox(height: 70),
              Align(
                alignment: Alignment.center,
                child: Text(
                  l10n.orderPlacedSuccessfully,
                  textAlign: TextAlign.center,
                  style: AppStyles.medium24,
                ),
              ),
              const SizedBox(height: 70),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: l10n.trackOrder,
                  onPressed: () {
                    context.push(AppRoutes.trackOrderDetails, extra: orderId);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
