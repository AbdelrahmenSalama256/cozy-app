import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../customer_services/view/complaint_screen.dart';
import '../../customer_services/view/general_inquiry_screen.dart';
import '../../customer_services/view/return_request_screen.dart';

class CustomerServiceScreen extends StatelessWidget {
  const CustomerServiceScreen({super.key});

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
          'customer_service'.tr(context),
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
            Text(
              'how_can_we_help'.tr(context),
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'choose_service_below'.tr(context),
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textGrey,
              ),
            ),
            SizedBox(height: 24.h),
            _buildServiceCard(
              context,
              'General Inquiry',
              'Ask questions about our products and services',
              Icons.help_outline,
              AppColors.primary,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GeneralInquiryScreen(),
                ),
              ),
            ),
            _buildServiceCard(
              context,
              'Return & Refund',
              'Request returns or refunds for your orders',
              Icons.assignment_return,
              AppColors.orange,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReturnRequestScreen(),
                ),
              ),
            ),
            _buildServiceCard(
              context,
              'Complaint & Feedback',
              'Share your feedback or report an issue',
              Icons.feedback_outlined,
              AppColors.error,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ComplaintScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textGrey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textGrey,
                  size: 16.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
