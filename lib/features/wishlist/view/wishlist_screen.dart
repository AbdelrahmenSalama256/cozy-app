import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/auth/view/login_screen.dart';
import 'package:cozy/features/home/data/model/product_model.dart';
import 'package:cozy/features/home/view/widgets/product_card.dart';
import 'package:cozy/features/product/view/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  bool isLoggedIn = true; // This would come from your auth state management
  List<ProductModel> favoriteProducts = [
    sampleProductsNewArrivals[0],
    sampleProductsPopular[1],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: SafeArea(
        child: isLoggedIn ? _buildFavoritesContent() : _buildGuestFavorites(),
      ),
    );
  }

  Widget _buildFavoritesContent() {
    if (favoriteProducts.isEmpty) {
      return _buildEmptyFavorites();
    }

    return Column(
      children: [
        // Header
        Padding(
          padding: EdgeInsets.all(20.w),
          child: Row(
            children: [
              Text(
                'favorites'.tr(context),
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              const Spacer(),
              Text(
                '${favoriteProducts.length} ${'items'.tr(context)}',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
        ),

        // Favorites Grid
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15.w,
              mainAxisSpacing: 15.h,
              childAspectRatio: 0.70,
            ),
            itemCount: favoriteProducts.length,
            itemBuilder: (context, index) {
              final product = favoriteProducts[index];
              return ProductCard(
                product: product,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailsScreen(product: product),
                    ),
                  );
                },
                onFavoriteTap: () {
                  setState(() {
                    favoriteProducts.removeAt(index);
                  });
                },
              );
            },
          ),
        ),

        SizedBox(height: 100.h), // Space for floating nav bar
      ],
    );
  }

  Widget _buildEmptyFavorites() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_outline,
            size: 100.sp,
            color: AppColors.textGrey,
          ),
          SizedBox(height: 24.h),
          Text(
            'empty_favorites'.tr(context),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'empty_favorites_message'.tr(context),
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textGrey,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40.h),
          ElevatedButton(
            onPressed: () {
              // Navigate to home or categories
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
            child: Text(
              'explore_products'.tr(context),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestFavorites() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_outline,
              size: 100.sp,
              color: AppColors.textGrey,
            ),
            SizedBox(height: 24.h),
            Text(
              'login_to_view_favorites'.tr(context),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'login_favorites_message'.tr(context),
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textGrey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                ),
                child: Text(
                  'login'.tr(context),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
