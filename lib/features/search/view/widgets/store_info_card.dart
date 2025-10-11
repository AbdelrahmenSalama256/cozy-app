import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//! StoreInfoCard
class StoreInfoCard extends StatelessWidget {
  final String logoUrl;
  final String nameKey;
  final bool isOnline;
  final double rating;
  final int reviewCount;
  final VoidCallback? onVisitStore;

  const StoreInfoCard({
    super.key,
    required this.logoUrl,
    required this.nameKey,
    required this.isOnline,
    required this.rating,
    required this.reviewCount,
    this.onVisitStore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4.r),

        border: Border.all(color: AppColors.lightGrey.withOpacity(0.5)),








      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              logoUrl,
              width: 50.w,
              height: 50.w,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 50.w,
                height: 50.w,
                color: AppColors.lightGrey,
                child: Icon(Icons.storefront,
                    color: AppColors.textGrey, size: 24.sp),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nameKey.tr(context),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: isOnline
                            ? AppColors.gradientThree
                            : AppColors.textGrey.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      isOnline
                          ? 'store_status_online'.tr(context)
                          : 'store_status_offline'.tr(context),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isOnline
                            ? AppColors.gradientThree
                            : AppColors.textGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text("•",
                        style: TextStyle(
                            color: AppColors.textGrey, fontSize: 12.sp)),
                    SizedBox(width: 8.w),
                    Icon(Icons.star, color: AppColors.orange, size: 14.sp),
                    SizedBox(width: 4.w),
                    Text(
                      '$rating (${'review_count_text'.tr(context)})',
                      style:
                          TextStyle(fontSize: 12.sp, color: AppColors.textGrey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (onVisitStore != null)
            TextButton(
              onPressed: onVisitStore,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                backgroundColor: AppColors.primary.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r)),
              ),
              child: Text(
                'store_visit_button'.tr(context),
                style: TextStyle(
                  color: AppColors.primaryLight,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
