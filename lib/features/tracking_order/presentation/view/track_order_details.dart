import 'package:flowrist/core/constants/app_dimensions.dart';
import 'package:flowrist/core/constants/app_images.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/features/tracking_order/presentation/cubit/tracking_cubit.dart';
import 'package:flowrist/features/tracking_order/presentation/cubit/tracking_state.dart';
import 'package:flowrist/features/tracking_order/presentation/view/widgets/tracking_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrackOrderDetails extends StatelessWidget {
  const TrackOrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Track order')),
      body: BlocBuilder<TrackingCubit, TrackingState>(
        builder: (context, state) {
          // Initial loading
          if (state.isLoading && state.tracking == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // Initial error
          if (state.errorMessage != null && state.tracking == null) {
            return Center(child: Text(state.errorMessage!));
          }

          final tracking = state.tracking;

          // No data
          if (tracking == null) {
            return const SizedBox.shrink();
          }

          // =====================================================
          // ORDER NOT ACCEPTED YET
          // =====================================================

          if (tracking.status == 'PLACED') {
            return const WaitingForDriverView();
          }

          // =====================================================
          // DRIVER ACCEPTED
          // PREPARING / PICKED_UP / OUT_FOR_DELIVERY / DELIVERED
          // =====================================================

          return TrackingContent(tracking: tracking);
        },
      ),
    );
  }
}

class WaitingForDriverView extends StatelessWidget {
  const WaitingForDriverView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.defaultScreenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.flowerTrackingOrderBoy,
              height: 120,
              width: 120,
            ),

            const SizedBox(height: 24),

            Text(
              'Waiting for driver',
              style: AppStyles.medium16InterBlack,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              'Your order has been placed. '
              'We are waiting for a driver to accept it.',
              style: AppStyles.regular14Inter,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
