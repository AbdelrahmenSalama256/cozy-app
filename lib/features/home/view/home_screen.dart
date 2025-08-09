import 'package:cozy/core/component/custom_loading_indicator.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/constants/navigation.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/home/view/cubit/home_cubit.dart';
import 'package:cozy/features/home/view/offers_screen.dart';
import 'package:cozy/features/home/view/widgets/category_chip.dart';
import 'package:cozy/features/home/view/widgets/product_card.dart';
import 'package:cozy/features/product/view/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/cubit/global_cubit.dart';
import '../../../core/cubit/global_state.dart';
import '../../customer_services/view/customer_service_screen.dart';
import '../../notifications/view/notification_screen.dart';
import 'cubit/home_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final cubit = context.read<HomeCubit>();
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !cubit.isLoadingMore &&
        cubit.hasMore) {
      setState(() {
        _isLoadingMore = true;
      });
      cubit.fetchProducts().then((_) {
        setState(() {
          _isLoadingMore = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      backgroundColor: AppColors.white,
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading && state is HomeProductsLoading) {
            return Center(child: CustomLoadingIndicator());
          }

          final cubit = context.read<HomeCubit>();
          final categories = cubit.categories;
          final products = cubit.products;

          return BlocBuilder<GlobalCubit, GlobalState>(
            builder: (context, globalState) {
              return SafeArea(
                child: SingleChildScrollView(
                  controller: _scrollController,
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
                                      builder: (context) =>
                                          const NotificationsScreen(),
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
                      categories.isEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Center(
                                child: Text(
                                  'no_categories'.tr(context),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 40.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  final category = categories[index];
                                  return Padding(
                                    padding: EdgeInsets.only(right: 10.w),
                                    child: CategoryChip(
                                      label: category.name ?? 'Unknown',
                                      isSelected:
                                          index == cubit.selectedCategoryIndex,
                                      onTap: () {
                                        cubit.selectCategory(index);
                                      },
                                    ),
                                  );
                                },
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          borderRadius:
                                              BorderRadius.circular(20.r),
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
                      state is HomeProductsLoading
                          ? SizedBox(
                              height: 50.h,
                              child: Center(child: CustomLoadingIndicator()))
                          : products.isEmpty
                              ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.h),
                                  child: Center(
                                    child: Text(
                                      'no_products'.tr(context),
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppColors.textGrey,
                                      ),
                                    ),
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                        itemCount: products.length,
                                        itemBuilder: (context, index) {
                                          final product = products[index];
                                          return Padding(
                                            padding:
                                                EdgeInsets.only(right: 15.w),
                                            child: SizedBox(
                                              width: 170.w,
                                              child: ProductCard(
                                                imageUrl: product.imagePath,
                                                name: product.nameKey,
                                                storeName: product.storeNameKey,
                                                rating: product.rating,
                                                reviewCount:
                                                    product.reviewCount,
                                                price: product.price,
                                                oldPrice: product.oldPrice,
                                                isFavorite:
                                                    product.isFavourited,
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductDetailsScreen(
                                                        productId: int.parse(
                                                            product.id),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                onFavoriteTap: () {
                                                  context
                                                      .read<GlobalCubit>()
                                                      .addtowishlist(
                                                          productId: product.id
                                                              .toString());
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 30.h),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 15.w,
                                          mainAxisSpacing: 15.h,
                                          childAspectRatio: 0.75,
                                        ),
                                        itemCount: products.length +
                                            (cubit.hasMore ? 1 : 0),
                                        itemBuilder: (context, index) {
                                          if (index >= products.length) {
                                            return Center(
                                                child:
                                                    CustomLoadingIndicator());
                                          }
                                          final product = products[index];
                                          return ProductCard(
                                            imageUrl: product.imagePath,
                                            name: product.nameKey,
                                            storeName: product.storeNameKey,
                                            rating: product.rating,
                                            reviewCount: product.reviewCount,
                                            price: product.price,
                                            oldPrice: product.oldPrice,
                                            isFavorite: product.isFavourited,
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductDetailsScreen(
                                                    productId:
                                                        int.parse(product.id),
                                                  ),
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
                      if (_isLoadingMore && cubit.hasMore)
                        SizedBox(
                            height: 50.h,
                            child: Center(child: CustomLoadingIndicator())),
                      SizedBox(height: 15.h),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
