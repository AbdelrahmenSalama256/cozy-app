import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/home/data/model/category_model.dart';
import 'package:cozy/features/home/view/widgets/category_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryTabView extends StatelessWidget {
  const CategoryTabView({super.key});

  @override
  Widget build(BuildContext context) {
    // In a real app, this would come from a Cubit/Bloc or service
    final List<CategoryModel> categories = sampleCategories;

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return LargeCategoryCard(
          category: categories[index],
          onTap: () {
            if (kDebugMode) {
              print(
                  "Tapped on category: ${categories[index].nameKey.tr(context)}");
            }
            // Navigate to category specific screen
          },
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
    );
  }
}
