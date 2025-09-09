import 'package:cozy/core/component/custom_loading_indicator.dart';
import 'package:cozy/core/component/custom_toast.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/services/service_locator.dart';
import 'package:cozy/features/profile/data/models/order_model.dart';
import 'package:cozy/features/profile/data/models/tracking_event_model.dart';
import 'package:cozy/features/profile/view/cubit/orders_cubit.dart';
import 'package:cozy/features/profile/view/cubit/orders_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/component/widgets/app_button.dart';
import '../data/repo/orders_repo.dart';

class OrderTrackingDetailsScreen extends StatelessWidget {
  final String orderId;

  const OrderTrackingDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersCubit(sl<OrderRepo>())..getOrders(),
      child: BlocConsumer<OrdersCubit, OrdersState>(
        listener: (context, state) {
          if (state is OrderTrackingError) {
            showToast(
              context,
              message: state.error,
              state: ToastStates.error,
              duration: const Duration(seconds: 3),
            );
          }
          if (state is OrderLoaded) {
            if (kDebugMode) {
              print(
                  'Orders loaded: ${context.read<OrdersCubit>().orders.map((o) => o.id).toList()}');
            }
            // Trigger trackOrder after orders are loaded
            context.read<OrdersCubit>().trackOrder(orderId);
          }
        },
        builder: (context, state) {
          final cubit = context.read<OrdersCubit>();
          final order = cubit.getOrderById(orderId);
          final trackingEvents = state is OrderTrackingLoaded
              ? state.trackingEvents
              : <TrackingEvent>[];

          if (kDebugMode) {
            print(
                'Order ID: $orderId, Order found: ${order != null}, Tracking events: ${trackingEvents.length}');
          }

          if (state is OrderLoading || state is OrderTrackingLoading) {
            return const Scaffold(
              body: Center(child: CustomLoadingIndicator()),
            );
          }

          if (state is OrderError ||
              state is OrderTrackingError ||
              order == null) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 80.sp,
                      color: AppColors.textGrey,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      state is OrderTrackingError
                          ? 'Tracking error: ${state.error}'
                          : state is OrderError
                              ? 'Order error: ${state.error}'
                              : 'Order with ID $orderId not found'.tr(context),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    AppButton(
                      onPressed: () {
                        cubit.getOrders();
                      },
                      text: 'retry'.tr(context),
                    ),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back,
                    color: AppColors.textBlack, size: 20.sp),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                '${'order'.tr(context)} #${order.invoiceNo}',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTrackingNumberCard(context, order),
                  SizedBox(height: 20.h),
                  _buildTrackingProgress(context, trackingEvents),
                  SizedBox(height: 20.h),
                  _buildOrderSummary(context, order),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrackingNumberCard(BuildContext context, OrderModel order) {
    final trackingNumber = order.shippingDetails ?? 'N/A';
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'tracking_number'.tr(context),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textGrey,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  trackingNumber,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
              ),
              Expanded(
                child: AppButton(
                  text: 'copy'.tr(context),
                  onPressed: () {
                    // Implement clipboard copy
                    if (kDebugMode) {
                      print('Copied tracking number: $trackingNumber');
                    }
                  },
                  type: AppButtonType.secondary,
                  height: 36.h,
                  width: 80.w,
                  borderRadius: BorderRadius.circular(8.r),
                  borderColor: AppColors.primary,
                  prefixIcon: Icon(
                    Icons.copy,
                    size: 16.sp,
                    color: AppColors.primary,
                  ),
                  textStyle: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingProgress(
      BuildContext context, List<TrackingEvent> trackingEvents) {
    // Define tracking steps with explicit String types
    final steps = [
      {'title': 'order_confirmed', 'subtitle': 'order_confirmed_subtitle'},
      {'title': 'processing', 'subtitle': 'processing_subtitle'},
      {'title': 'shipped', 'subtitle': 'shipped_subtitle'},
      {'title': 'delivered', 'subtitle': 'delivered_subtitle'},
      {'title': 'cancelled', 'subtitle': 'cancelled_subtitle'},
    ];

    // Map tracking events to steps
    final stepStatus = steps.asMap().map((index, step) {
      final event = trackingEvents.firstWhere(
        (e) {
          final title = e.title.toLowerCase();
          if (title.contains('cancelled')) {
            return step['title']!.toLowerCase() == 'cancelled';
          }
          return title.contains(step['title']!.toLowerCase());
        },
        orElse: () => TrackingEvent(
          id: '',
          transactionId: '',
          title: '',
          text: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      return MapEntry(index, {
        'title': step['title'] as String,
        'subtitle': step['subtitle'] as String,
        'isCompleted': event.id.isNotEmpty,
        'hasNextStep': index < steps.length - 1,
      });
    });

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'tracking_progress'.tr(context),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 20.h),
          ...stepStatus.entries.map((entry) {
            final step = entry.value;
            return _buildTrackingStep(
              (step['title'] as String).tr(context),
              (step['subtitle'] as String).tr(context),
              step['isCompleted'] as bool,
              step['hasNextStep'] as bool,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTrackingStep(
      String title, String subtitle, bool isCompleted, bool hasNextStep) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.primary : AppColors.lightGrey,
                shape: BoxShape.circle,
              ),
              child: isCompleted
                  ? Icon(
                      Icons.check,
                      size: 12.sp,
                      color: Colors.white,
                    )
                  : null,
            ),
            if (hasNextStep)
              Container(
                width: 2.w,
                height: 40.h,
                color: isCompleted ? AppColors.primary : AppColors.lightGrey,
              ),
          ],
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isCompleted ? AppColors.textBlack : AppColors.textGrey,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textGrey,
                ),
              ),
              if (hasNextStep) SizedBox(height: 20.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary(BuildContext context, OrderModel order) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'order_summary'.tr(context),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Text(
                'order_date'.tr(context),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(order.transactionDate),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textBlack,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text(
                'items'.tr(context),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
              ),
              const Spacer(),
              Text(
                '${order.items.length}',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textBlack,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Divider(color: AppColors.lightGrey),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text(
                'total'.tr(context),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                ),
              ),
              const Spacer(),
              Text(
                '\$${order.finalTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
