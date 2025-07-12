import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/component/widgets/app_button.dart';
import '../../../core/constants/app_colors.dart';

class OrderTrackingDetailsScreen extends StatelessWidget {
  OrderTrackingDetailsScreen({super.key});

  // Fake data for UI
  final String orderId = 'ORD123456';
  final DateTime orderDate = DateTime(2025, 7, 10);
  final int orderItems = 3;
  final double orderTotal = 799.97;
  final String trackingNumber = 'TRK7890123';
  final String statusText = 'shipped'; // Translation key for status
  final bool isDelivered =
      false; // Simulates OrderStatus.shipped for tracking progress

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textBlack, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${'order'.tr(context)} #$orderId'.tr(context),
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
            _buildTrackingNumberCard(context),
            SizedBox(height: 20.h),
            _buildTrackingProgress(context),
            SizedBox(height: 20.h),
            _buildOrderSummary(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingNumberCard(BuildContext context) {
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
                    // Copy tracking number to clipboard (placeholder)
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

  Widget _buildTrackingProgress(BuildContext context) {
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
          _buildTrackingStep(
            'order_confirmed'.tr(context),
            'order_confirmed_subtitle'.tr(context),
            true,
            true,
          ),
          _buildTrackingStep(
            'processing'.tr(context),
            'processing_subtitle'.tr(context),
            true,
            true,
          ),
          _buildTrackingStep(
            'shipped'.tr(context),
            'shipped_subtitle'.tr(context),
            true,
            isDelivered,
          ),
          _buildTrackingStep(
            'delivered'.tr(context),
            'delivered_subtitle'.tr(context),
            isDelivered,
            false,
          ),
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

  Widget _buildOrderSummary(BuildContext context) {
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
                _formatDate(orderDate),
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
                '$orderItems',
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
                '\$${orderTotal.toStringAsFixed(2)}',
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
