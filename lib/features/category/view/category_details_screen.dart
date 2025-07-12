import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/home/view/widgets/category_chip.dart';
import 'package:cozy/features/home/view/widgets/product_card.dart';
import 'package:cozy/features/product/view/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../customer_services/view/customer_service_screen.dart';
import '../../notifications/view/notification_screen.dart';

class CategoryDetailsScreen extends StatelessWidget {
  CategoryDetailsScreen({super.key});

  final List<Map<String, dynamic>> products = [
    {
      'id': 'modern_sofa_001',
      'imageUrl': 'https://via.placeholder.com/120?text=Modern+Sofa',
      'nameKey': 'item_name_modern_velvet_sofa',
      'storeNameKey': 'store_name',
      'rating': 4.5,
      'reviewCount': 120,
      'price': 599.99,
      'oldPrice': 699.99,
      'isFavorite': false,
    },
    {
      'id': 'wooden_coffee_table_002',
      'imageUrl': 'https://via.placeholder.com/120?text=Coffee+Table',
      'nameKey': 'item_name_wooden_coffee_table',
      'storeNameKey': 'store_name',
      'rating': 4.2,
      'reviewCount': 85,
      'price': 199.99,
      'oldPrice': 249.99,
      'isFavorite': false,
    },
    {
      'id': 'leather_armchair_003',
      'imageUrl': 'https://via.placeholder.com/120?text=Leather+Armchair',
      'nameKey': 'item_name_leather_armchair',
      'storeNameKey': 'store_name',
      'rating': 4.7,
      'reviewCount': 95,
      'price': 349.99,
      'oldPrice': 399.99,
      'isFavorite': false,
    },
    {
      'id': 'bookshelf_004',
      'imageUrl': 'https://via.placeholder.com/120?text=Bookshelf',
      'nameKey': 'item_name_modern_bookshelf',
      'storeNameKey': 'store_name',
      'rating': 4.0,
      'reviewCount': 60,
      'price': 149.99,
      'oldPrice': 179.99,
      'isFavorite': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'furniture_category'.tr(context),
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textBlack,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${products.length} items'.tr(context),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textGrey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationsScreen(),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CustomerServiceScreen(),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.support_agent_outlined,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'search_hint'.tr(context),
                      hintStyle: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 14.sp,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.textGrey,
                        size: 20.sp,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 15.h,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              SizedBox(
                height: 40.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  children: [
                    CategoryChip(
                      label: 'all'.tr(context),
                      isSelected: true,
                    ),
                    SizedBox(width: 10.w),
                    CategoryChip(label: 'featured'.tr(context)),
                    SizedBox(width: 10.w),
                    CategoryChip(label: 'new'.tr(context)),
                    SizedBox(width: 10.w),
                    CategoryChip(label: 'popular'.tr(context)),
                    SizedBox(width: 20.w),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15.w,
                    mainAxisSpacing: 15.h,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(
                      imageUrl: product['imageUrl'],
                      name: product['nameKey'],
                      storeName: product['storeNameKey'],
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
                      onFavoriteTap: () {},
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
