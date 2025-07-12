import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/profile/data/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/component/widgets/app_button.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;
  final VoidCallback? onTrackTap;
  final VoidCallback? onCancelTap; // New callback for cancellation

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    this.onTrackTap,
    this.onCancelTap, // Optional callback for cancellation
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${'order'.tr(context)} #${order.id}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: order.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      order.statusText.tr(context),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: order.statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                _formatDate(order.date),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textGrey,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 16.sp,
                    color: AppColors.textGrey,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${order.items} ${'items'.tr(context)}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textGrey,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '\$${order.total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              if (order.trackingNumber != null) ...[
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      Icons.local_shipping_outlined,
                      size: 16.sp,
                      color: AppColors.textGrey,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${'tracking'.tr(context)}: ${order.trackingNumber}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(height: 12.h),
              Row(
                children: [
                  if (order.status == OrderStatus.shipped &&
                      onTrackTap != null) ...[
                    Expanded(
                      child: AppButton(
                        text: 'track_order'.tr(context),
                        onPressed: onTrackTap,
                        type: AppButtonType.secondary,
                        height: 36.h,
                        borderRadius: BorderRadius.circular(8.r),
                        borderColor: AppColors.primary,
                        textStyle: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                  ],
                  if (order.status == OrderStatus.processing &&
                      onCancelTap != null) ...[
                    Expanded(
                      child: AppButton(
                        text: 'cancel_order'.tr(context),
                        onPressed: () {
                          _showCancelOrderDialog(context);
                        },
                        type: AppButtonType.secondary,
                        height: 36.h,
                        borderRadius: BorderRadius.circular(8.r),
                        borderColor: Colors.red,
                        textStyle: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                  ],
                  Expanded(
                    child: AppButton(
                      text: 'view_details'.tr(context),
                      onPressed: onTap,
                      type: AppButtonType.primary,
                      height: 36.h,
                      borderRadius: BorderRadius.circular(8.r),
                      backgroundColor: AppColors.primary,
                      textStyle: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
          title: Text(
            'cancel_order'.tr(context),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
          ),
          content: Text(
            'are_you_sure_cancel_order'.tr(context),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textGrey,
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'no'.tr(context),
                    onPressed: () => Navigator.pop(context),
                    type: AppButtonType.secondary,
                    height: 36.h,
                    borderRadius: BorderRadius.circular(8.r),
                    borderColor: AppColors.textGrey,
                    textStyle: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textGrey,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.h,
                ),
                Expanded(
                  child: AppButton(
                    text: 'yes_cancel'.tr(context),
                    onPressed: () {
                      Navigator.pop(context);
                      onCancelTap?.call();
                    },
                    type: AppButtonType.primary,
                    height: 36.h,
                    borderRadius: BorderRadius.circular(8.r),
                    backgroundColor: Colors.red,
                    textStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
