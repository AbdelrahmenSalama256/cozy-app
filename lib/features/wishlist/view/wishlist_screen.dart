import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/auth/view/login_screen.dart';
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
  bool isLoggedIn = true;
  List<Map<String, dynamic>> favoriteProducts = [
    {
      'imageUrl': 'https://via.placeholder.com/120',
      'name': 'item_name_0',
      'storeName': 'store_name',
      'rating': 4.5,
      'reviewCount': 10,
      'price': 99.99,
      'oldPrice': 120.00,
      'isFavorite': true,
    },
    {
      'imageUrl': 'https://via.placeholder.com/120',
      'name': 'item_name_1',
      'storeName': 'store_name',
      'rating': 4.5,
      'reviewCount': 10,
      'price': 99.99,
      'oldPrice': 120.00,
      'isFavorite': true,
    },
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
                imageUrl: product['imageUrl'],
                name: product['name'],
                storeName: product['storeName'],
                rating: product['rating'],
                reviewCount: product['reviewCount'],
                price: product['price'],
                oldPrice: product['oldPrice'],
                isFavorite: product['isFavorite'],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductDetailsScreen(),
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
          AppButton(
            onPressed: () {
              // Navigate to home or categories
            },
            text: 'explore_products'.tr(context),
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
              child: AppButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                text: 'login'.tr(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
