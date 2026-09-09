import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/features/home/profile/my_orders/presentation/view/order_details_view.dart';
import 'package:flowrist/features/home/profile/my_orders/presentation/view/widgets/order_card_widget.dart';
import 'package:flowrist/features/home/profile/my_orders/presentation/view/widgets/orders_empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/features/home/profile/my_orders/domain/entities/order_entity.dart';
import 'package:flowrist/features/home/profile/my_orders/presentation/cubit/orders_cubit.dart';
import 'package:flowrist/features/home/profile/my_orders/presentation/cubit/orders_events.dart';
import 'package:flowrist/features/home/profile/my_orders/presentation/cubit/orders_state.dart';

class MyOrdersView extends StatelessWidget {
  const MyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrdersCubit>()..doEvent(const LoadOrdersEvent()),
      child: const _MyOrdersView(),
    );
  }
}

class _MyOrdersView extends StatelessWidget {
  const _MyOrdersView();

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
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
          title: Text(locale.myOrders, style: AppStyles.medium18Inter),
          titleSpacing: 0,
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: AppColors.purpleBase,
            indicatorWeight: 3,
            labelColor: AppColors.purpleBase,
            unselectedLabelColor: AppColors.grey20,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            tabs: [
              Tab(text: locale.active),
              Tab(text: locale.completed),
            ],
          ),
        ),
        body: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            if (state.status == OrdersStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.purpleBase),
              );
            }

            if (state.status == OrdersStatus.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.errorMessage ?? locale.generalValidationError,
                      style: AppStyles.regular14Inter,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purpleBase,
                      ),
                      onPressed: () => context.read<OrdersCubit>().doEvent(
                        const LoadOrdersEvent(),
                      ),
                      child: Text(locale.retry, style: AppStyles.medium16Inter),
                    ),
                  ],
                ),
              );
            }

            return TabBarView(
              children: [
                _buildOrdersList(context, state.activeOrders),
                _buildOrdersList(context, state.completedOrders),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context, List<OrderEntity> orders) {
    if (orders.isEmpty) {
      return const OrdersEmptyStateWidget();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderCardWidget(
          order: order,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => OrderDetailsView(orderId: order.id),
              ),
            );
          },
          onActionPressed: () {
            if (order.displayStatus == OrderDisplayStatus.active) {
              // Action: Track Order
            } else {
              // Action: Reorder
            }
          },
        );
      },
    );
  }
}
