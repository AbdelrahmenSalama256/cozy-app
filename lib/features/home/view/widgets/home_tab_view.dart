import 'package:cozy/core/component/widgets/app_title.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/home/data/model/product_model.dart';
import 'package:cozy/features/home/view/widgets/product_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample product lists (replace with actual data source)
    final List<ProductModel> newArrivals = sampleProductsNewArrivals;
    final List<ProductModel> popularProducts = sampleProductsPopular;
    final List<String> bannerImageUrls = [
      "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixlib=rb-4.0.3&auto=format&fit=crop&w=340&h=160&q=80",
      "https://images.unsplash.com/photo-1556905055-8f358a7a47b2?ixlib=rb-4.0.3&auto=format&fit=crop&w=340&h=160&q=80",
      "https://images.unsplash.com/photo-1542291026-7eec264c27ff?ixlib=rb-4.0.3&auto=format&fit=crop&w=340&h=160&q=80",
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 180.h,
            child: PageView.builder(
              itemCount: bannerImageUrls.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      bannerImageUrls[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.lightGrey,
                        child: const Center(child: Text("Banner Image")),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SectionHeader(
              titleKey: 'home_new_arrivals_title'.tr(context),
              onSeeAllTap: () {
                if (kDebugMode) {
                  print("See All New Arrivals Tapped");
                }
              },
            ),
          ),
          SizedBox(height: 12.h),
          newArrivals.isEmpty
              ? Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    'No new arrivals available',
                    style:
                        TextStyle(fontSize: 16.sp, color: AppColors.textGrey),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 16.w, right: 6.w),
                  itemCount: newArrivals.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: ProductCard(
                        product: newArrivals[index],
                        onTap: () {
                          if (kDebugMode) {
                            print(
                                "Tapped on ${newArrivals[index].nameKey.tr(context)}");
                          }
                        },
                        onFavoriteTap: () {
                          if (kDebugMode) {
                            print(
                                "Favorite toggled for ${newArrivals[index].nameKey.tr(context)}");
                          }
                        },
                      ),
                    );
                  },
                ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SectionHeader(
              titleKey: 'home_popular_products_title'.tr(context),
              onSeeAllTap: () {
                if (kDebugMode) {
                  print("See All Popular Products Tapped");
                }
              },
            ),
          ),
          SizedBox(height: 12.h),
          popularProducts.isEmpty
              ? Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    'No popular products available',
                    style:
                        TextStyle(fontSize: 16.sp, color: AppColors.textGrey),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      popularProducts.length > 4 ? 4 : popularProducts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    mainAxisSpacing: 16.h,
                    crossAxisSpacing: 16.w,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: popularProducts[index],
                      onTap: () {
                        if (kDebugMode) {
                          print(
                              "Tapped on ${popularProducts[index].nameKey.tr(context)}");
                        }
                      },
                      onFavoriteTap: () {
                        if (kDebugMode) {
                          print(
                              "Favorite toggled for ${popularProducts[index].nameKey.tr(context)}");
                        }
                      },
                    );
                  },
                ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
