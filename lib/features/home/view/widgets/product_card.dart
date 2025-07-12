import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/home/view/widgets/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String storeName;
  final double rating;
  final int reviewCount;
  final double price;
  final double? oldPrice;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.storeName,
    required this.rating,
    required this.reviewCount,
    required this.price,
    this.oldPrice,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16.r)),
                  child: Image.asset(
                    imageUrl,
                    width: double.infinity,
                    height: 110.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 110.h,
                      width: double.infinity,
                      color: AppColors.lightGrey,
                      child: Icon(Icons.image_not_supported,
                          color: AppColors.textGrey, size: 30.sp),
                    ),
                  ),
                ),
                Positioned(
                  top: 6.h,
                  right: 6.w,
                  child: FavoriteButton(
                    isFavorited: isFavorite,
                    onFavoriteToggle: onFavoriteTap ?? () {},
                    size: 18.sp,
                  ),
                ),
                // الخصم
                if (oldPrice != null)
                  Positioned(
                    top: 6.h,
                    left: 6.w,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        '-${(((oldPrice! - price) / oldPrice!) * 100).round()}%',
                        style: TextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // باقي بيانات المنتج
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.tr(context),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    storeName.tr(context),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.textGrey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.star, color: AppColors.warning, size: 10.sp),
                      SizedBox(width: 2.w),
                      Text(
                        '$rating ($reviewCount)',
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      if (oldPrice != null) ...[
                        SizedBox(width: 4.w),
                        Text(
                          '\$${oldPrice!.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.textGrey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
