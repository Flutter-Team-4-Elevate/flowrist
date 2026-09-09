import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/features/home/profile/my_orders/presentation/cubit/orders_cubit.dart';
import 'package:flowrist/features/home/profile/my_orders/presentation/cubit/orders_events.dart';
import 'package:flowrist/features/home/profile/my_orders/presentation/cubit/orders_state.dart';
import 'package:flowrist/features/home/profile/my_orders/presentation/view/widgets/orders_empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDetailsView extends StatelessWidget {
  final String orderId;

  const OrderDetailsView({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) =>
          getIt<OrdersCubit>()..doEvent(LoadOrderDetailsEvent(orderId)),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.blackBase,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: Text(locale.orderDetails, style: AppStyles.medium18Inter),
          titleSpacing: 0,
        ),
        body: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            if (state.isLoadingDetails) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.purpleBase),
              );
            }

            final details = state.selectedOrderDetails;
            if (details == null) {
              return OrdersEmptyStateWidget(message: locale.noOrdersFound);
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${locale.orderNumberPrefix} ${details.orderNumber}',
                    style: AppStyles.bold20Inter,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(locale.status, details.status),
                  _buildDetailRow(locale.paymentMethod, details.paymentMethod),
                  _buildDetailRow(locale.paymentStatus, details.paymentStatus),
                  const Divider(height: 32, color: AppColors.white60),
                  _buildDetailRow(
                    locale.subTotal,
                    '${locale.egp} ${details.subtotal}',
                  ),
                  _buildDetailRow(
                    locale.deliveryFee,
                    '${locale.egp} ${details.deliveryFee}',
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    locale.total,
                    '${locale.egp} ${details.total}',
                    isTotal: true,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: isTotal
                ? AppStyles.medium16InterBlack
                : AppStyles.regular14Inter,
          ),
          Text(
            value,
            style: isTotal
                ? AppStyles.bold20Inter
                : AppStyles.regular14InterW500,
          ),
        ],
      ),
    );
  }
}
