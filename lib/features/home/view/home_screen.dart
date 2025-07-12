import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/constants/navigation.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/home/view/offers_screen.dart';
import 'package:cozy/features/home/view/widgets/category_chip.dart';
import 'package:cozy/features/home/view/widgets/product_card.dart';
import 'package:cozy/features/product/view/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../customer_services/view/customer_service_screen.dart';
import '../../notifications/view/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> demoProducts = [
    {
      'imageUrl':
          'assets/images/furniture-styles-GettyImages-1467984982-512fed4077b646eabbc187619554d517.jpg',
      'name': 'Modern Sofa',
      'storeName': 'IKEA',
      'rating': 4.7,
      'reviewCount': 145,
      'price': 799.99,
      'oldPrice': 999.99,
      'isFavorite': true,
    },
    {
      'imageUrl':
          'assets/images/furniture-styles-GettyImages-1467984982-512fed4077b646eabbc187619554d517.jpg',
      'name': 'Wooden Bed',
      'storeName': 'Home Center',
      'rating': 4.2,
      'reviewCount': 87,
      'price': 599.99,
      'oldPrice': 749.99,
      'isFavorite': false,
    },
    {
      'imageUrl':
          'assets/images/furniture-styles-GettyImages-1467984982-512fed4077b646eabbc187619554d517.jpg',
      'name': 'Dining Table Set',
      'storeName': 'Furniture World',
      'rating': 4.8,
      'reviewCount': 200,
      'price': 899.99,
      'oldPrice': 999.99,
      'isFavorite': true,
    },
    {
      'imageUrl':
          'assets/images/furniture-styles-GettyImages-1467984982-512fed4077b646eabbc187619554d517.jpg',
      'name': 'Office Chair',
      'storeName': 'Ergo Store',
      'rating': 4.3,
      'reviewCount': 60,
      'price': 299.99,
      'oldPrice': 399.99,
      'isFavorite': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
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
                            'welcome_message'.tr(context),
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
                            'quality_furniture'.tr(context),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'explore_categories'.tr(context),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              SizedBox(
                height: 40.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  children: [
                    CategoryChip(
                        label: 'living_room'.tr(context), isSelected: true),
                    SizedBox(width: 10.w),
                    CategoryChip(label: 'bedroom'.tr(context)),
                    SizedBox(width: 10.w),
                    CategoryChip(label: 'kitchen'.tr(context)),
                    SizedBox(width: 10.w),
                    CategoryChip(label: 'office'.tr(context)),
                    SizedBox(width: 20.w),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: GestureDetector(
                  onTap: () {
                    navigateTo(context, OffersScreen());
                  },
                  child: Container(
                    height: 150.h,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                        colors: [
                          AppColors.primary,
                          AppColors.primaryLight,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Stack(
                      children: [
                        PositionedDirectional(
                          start: 20.w,
                          top: 20.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'special_offers'.tr(context),
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Up to 50% Off',
                                style: TextStyle(
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  'see_all'.tr(context),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: -20.w,
                          bottom: -20.h,
                          child: Container(
                            width: 120.w,
                            height: 120.w,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(60.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'new_arrivals'.tr(context),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                    Text(
                      'see_all'.tr(context),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              SizedBox(
                height: 220.h,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(left: 20.w),
                    itemCount: demoProducts.length,
                    itemBuilder: (context, index) {
                      final product = demoProducts[index];
                      return Padding(
                        padding: EdgeInsets.only(right: 15.w),
                        child: SizedBox(
                          width: 170.w,
                          child: ProductCard(
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
                                  builder: (context) =>
                                      const ProductDetailsScreen(),
                                ),
                              );
                            },
                            onFavoriteTap: () {},
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'popular_products'.tr(context),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                    Text(
                      'see_all'.tr(context),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15.w,
                    mainAxisSpacing: 15.h,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: demoProducts.length,
                  itemBuilder: (context, index) {
                    final product = demoProducts[index];

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
                      onFavoriteTap: () {},
                    );
                  },
                ),
              ),
              SizedBox(height: 15.h),
            ],
          ),
        ),
      ),
    );
  }
}
