import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/constants/navigation.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/profile/data/models/order_model.dart';
import 'package:cozy/features/profile/view/order_details_screen.dart';
import 'package:cozy/features/profile/view/widgets/order_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/component/custom_toast.dart';
import 'tracking_orders_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<OrderModel> allOrders = [
    OrderModel(
      id: 'ORD001',
      date: DateTime.now().subtract(const Duration(days: 2)),
      status: OrderStatus.delivered,
      total: 299.99,
      items: 2,
      trackingNumber: 'TRK123456789',
    ),
    OrderModel(
      id: 'ORD002',
      date: DateTime.now().subtract(const Duration(days: 5)),
      status: OrderStatus.shipped,
      total: 899.99,
      items: 1,
      trackingNumber: 'TRK987654321',
    ),
    OrderModel(
      id: 'ORD003',
      date: DateTime.now().subtract(const Duration(days: 10)),
      status: OrderStatus.processing,
      total: 549.98,
      items: 2,
    ),
    OrderModel(
      id: 'ORD004',
      date: DateTime.now().subtract(const Duration(days: 30)),
      status: OrderStatus.cancelled,
      total: 199.99,
      items: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'my_orders'.tr(context),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textGrey,
          indicatorColor: AppColors.primary,
          tabs: [
            Tab(text: 'all'.tr(context)),
            Tab(text: 'processing'.tr(context)),
            Tab(text: 'shipped'.tr(context)),
            Tab(text: 'delivered'.tr(context)),
            Tab(text: 'cancelled'.tr(context)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList(allOrders),
          _buildOrdersList(_filterOrders(OrderStatus.processing)),
          _buildOrdersList(_filterOrders(OrderStatus.shipped)),
          _buildOrdersList(_filterOrders(OrderStatus.delivered)),
          _buildOrdersList(_filterOrders(OrderStatus.cancelled)),
        ],
      ),
    );
  }

  List<OrderModel> _filterOrders(OrderStatus status) {
    return allOrders.where((order) => order.status == status).toList();
  }

  Widget _buildOrdersList(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 80.sp,
              color: AppColors.textGrey,
            ),
            SizedBox(height: 16.h),
            Text(
              'no_orders_found'.tr(context),
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return OrderCard(
          order: orders[index],
          onTap: () {
            navigateTo(context, const OrderDetailsScreen());
          },
          onTrackTap: orders[index].trackingNumber != null
              ? () {
                  navigateTo(context, OrderTrackingDetailsScreen());
                }
              : null,
          onCancelTap: orders[index].status == OrderStatus.processing
              ? () {
                  if (kDebugMode) {
                    print('Cancel order #${orders[index].id}');
                  }
                  setState(() {
                    allOrders[index] = OrderModel(
                      id: orders[index].id,
                      date: orders[index].date,
                      status: OrderStatus.cancelled,
                      total: orders[index].total,
                      items: orders[index].items,
                      trackingNumber: orders[index].trackingNumber,
                      orderItems: orders[index].orderItems,
                    );
                  });
                  showToast(
                    context,
                    message: 'order_cancelled'
                        .tr(context), // Add this key to your localization
                    state: ToastStates.success,
                    duration: const Duration(seconds: 3),
                  );
                }
              : null,
        );
      },
    );
  }
}
