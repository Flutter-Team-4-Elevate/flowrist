import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_dimensions.dart';
import 'package:flowrist/core/constants/app_images.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/features/tracking_order/presentation/cubit/tracking_cubit.dart';
import 'package:flowrist/features/tracking_order/presentation/cubit/tracking_state.dart';
import 'package:flowrist/features/tracking_order/presentation/view/widgets/tracking_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class TrackOrderDetails extends StatelessWidget {
  const TrackOrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(l10n.trackOrder),
      ),
      body: BlocBuilder<TrackingCubit, TrackingState>(
        buildWhen: (previous, current) =>
            previous.isLoading != current.isLoading ||
            previous.errorMessage != current.errorMessage ||
            previous.tracking != current.tracking ||
            previous.estimatedDeliveryAt != current.estimatedDeliveryAt,
        builder: (context, state) {
          if (state.isLoading && state.tracking == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null && state.tracking == null) {
            return Center(child: Text(state.errorMessage!));
          }

          final tracking = state.tracking;

          if (tracking == null) {
            return const Center(
              child: Text(
                'No Data please try again',
                textAlign: TextAlign.center,
              ),
            );
          }

          if (tracking.status == 'PLACED') {
            return const WaitingForDriverView();
          }

          return TrackingContent(
            tracking: tracking,
            estimatedDeliveryAt: state.estimatedDeliveryAt,
          );
        },
      ),
    );
  }
}

class WaitingForDriverView extends StatelessWidget {
  const WaitingForDriverView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.defaultScreenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie animation
            SizedBox(
              height: 220,
              width: 220,
              child: Lottie.asset(
                AppImages.waitingForDriverLottie,
                repeat: true,
                height: 120,
                width: 120,
              ),
            ),

            const SizedBox(height: 24),

            // Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.purple20.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      color: AppColors.purpleBase,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.waitingForDriver,
                    style: AppStyles.regular13.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Text(
                l10n.waitingForDriverDescription,
                style: AppStyles.regular14Inter,
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
