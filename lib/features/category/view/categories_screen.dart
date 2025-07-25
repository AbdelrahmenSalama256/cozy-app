import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                children: [
                  Text(
                    'categories'.tr(context),
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                ],
              ),
            ),

            // Categories Grid
            // Expanded(
            //   child: GridView.builder(
            //     padding: EdgeInsets.symmetric(horizontal: 20.w),
            //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 2,
            //       crossAxisSpacing: 15.w,
            //       mainAxisSpacing: 15.h,
            //       childAspectRatio: 0.58,
            //     ),
            //     itemCount: sampleCategories.length,
            //     itemBuilder: (context, index) {
            //       final category = sampleCategories[index];
            //       return CategoryCard(
            //         category: category,
            //         onTap: () {
            //           navigateTo(context, CategoryDetailsScreen());
            //         },
            //       );
            //     },
            //   ),
            // ),
            // SizedBox(height: 15.h),
          ],
        ),
      ),
    );
  }
}
