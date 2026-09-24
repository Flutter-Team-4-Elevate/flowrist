import 'package:flowrist/core/constants/app_dimensions.dart';
import 'package:flowrist/core/constants/app_images.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/ui/widgets/app_button.dart';
import 'package:flowrist/features/tracking_order/presentation/widgets/dummy_timeline.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TrackOrderDetails extends StatelessWidget {
  const TrackOrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    const String time = "11:00 AM";
    const String arrivalDate = "03 Sep 2024";
    const String driverName = "Mohammad";
    const OrderStatus currentStatus = OrderStatus.preparing;

    return Scaffold(
      appBar: AppBar(title: const Text("Track order")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.defaultScreenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Estimated arrival', style: AppStyles.regular14Inter),

              Text("$arrivalDate, $time", style: AppStyles.medium16InterBlack),

              const SizedBox(height: 40),

              Row(
                children: [
                  const SizedBox(width: 20),

                  SizedBox(
                    height: 36,
                    width: 36,
                    child: Image.asset(AppImages.flowerTrackingOrderBoy),
                  ),

                  const SizedBox(width: 20),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(driverName, style: AppStyles.regular14InterW500),
                      Text(
                        'Is your delivery hero for today',
                        style: AppStyles.regular13,
                      ),
                    ],
                  ),

                  const Spacer(),

                  SizedBox(
                    height: 18,
                    width: 18,
                    child: Image.asset(AppImages.flowerTrackingOrderCall),
                  ),

                  const SizedBox(width: 10),

                  SizedBox(
                    height: 18,
                    width: 18,
                    child: Image.asset(AppImages.flowerTrackingOrderWattsapp),
                  ),

                  const SizedBox(width: 20),
                ],
              ),

              const SizedBox(height: 50),

              Center(
                child: SizedBox(
                  height: 83,
                  width: 213,
                  child: Image.asset(AppImages.flowerTrackingOrderCar),
                ),
              ),

              const SizedBox(height: 50),

              const OrderStatusTimeline(),

              const SizedBox(height: 30),

              if (currentStatus == OrderStatus.delivered) ...[
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: "Show map",
                        onPressed: () {
                          context.push('/tracking_map');
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        text: "Order Delivered",
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    text: "Show map",
                    onPressed: () {
                      context.push('/tracking_map');
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
