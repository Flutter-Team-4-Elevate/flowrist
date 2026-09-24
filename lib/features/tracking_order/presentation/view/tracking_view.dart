import 'package:flowrist/core/constants/app_dimensions.dart';
import 'package:flowrist/core/constants/app_images.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/ui/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TrackingView extends StatelessWidget {
  const TrackingView({super.key, required this.orderId});
  final String orderId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.go(AppRoutes.homeTab);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Track order"),
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
                  'Your order placed successfully!',
                  textAlign: TextAlign.center,
                  style: AppStyles.medium24,
                ),
              ),
              const SizedBox(height: 70),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: "Track order",
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
