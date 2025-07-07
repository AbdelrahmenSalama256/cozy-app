import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/profile/data/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
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
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        order.statusText,
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
                    if (order.status == OrderStatus.shipped) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Track order
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'track_order'.tr(context),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                    ],
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'view_details'.tr(context),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
