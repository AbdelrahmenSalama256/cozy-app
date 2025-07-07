import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/home/data/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const ProductCard({
    super.key,
    required this.product,
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
            // Image section - Fixed height
            SizedBox(
              height: 120.h, // Reduced from 140.h
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16.r)),
                    child: Image.network(
                      product.imagePath,
                      width: double.infinity,
                      height: 120.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: double.infinity,
                        height: 120.h,
                        color: AppColors.lightGrey,
                        child: Icon(
                          Icons.image_not_supported,
                          color: AppColors.textGrey,
                          size: 30.sp, // Reduced icon size
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6.h,
                    right: 6.w,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: Container(
                        width: 28.w, // Reduced from 32.w
                        height: 28.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: product.isFavorite
                              ? AppColors.error
                              : AppColors.textGrey,
                          size: 14.sp, // Reduced from 16.sp
                        ),
                      ),
                    ),
                  ),
                  if (product.oldPrice != null)
                    Positioned(
                      top: 6.h,
                      left: 6.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          '${(((product.oldPrice! - product.price) / product.oldPrice!) * 100).round()}%',
                          style: TextStyle(
                            fontSize: 8.sp, // Reduced from 9.sp
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content section - Flexible with better constraints
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 8.w, vertical: 6.h), // Reduced padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Text(
                      product.nameKey.tr(context),
                      style: TextStyle(
                        fontSize: 12.sp, // Reduced from 13.sp
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack,
                        height: 1.2, // Reduced line height
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 2.h),

                    // Store name
                    Text(
                      product.storeNameKey.tr(context),
                      style: TextStyle(
                        fontSize: 10.sp, // Reduced from 11.sp
                        color: AppColors.textGrey,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 3.h), // Reduced spacing

                    // Rating - More compact
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.warning,
                          size: 10.sp, // Reduced from 12.sp
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            '${product.rating} (${product.reviewCount})',
                            style: TextStyle(
                              fontSize: 9.sp, // Reduced from 10.sp
                              color: AppColors.textGrey,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Price section - More compact
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${product.currencySymbolKey.tr(context)}${product.price.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 13.sp, // Reduced from 14.sp
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (product.oldPrice != null) ...[
                          SizedBox(width: 4.w),
                          Text(
                            '${product.currencySymbolKey.tr(context)}${product.oldPrice!.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 9.sp, // Reduced from 10.sp
                              color: AppColors.textGrey,
                              decoration: TextDecoration.lineThrough,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
