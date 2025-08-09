import 'package:cozy/core/component/custom_loading_indicator.dart';
import 'package:cozy/core/component/custom_toast.dart';
import 'package:cozy/core/component/widgets/error_message_handler.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/constants/navigation.dart';
import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/home/view/cubit/home_cubit.dart';
import 'package:cozy/features/home/view/cubit/home_state.dart';
import 'package:cozy/features/home/view/widgets/category_chip.dart';
import 'package:cozy/features/home/view/widgets/product_card.dart';
import 'package:cozy/features/product/view/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/cubit/global_state.dart';
import '../../customer_services/view/customer_service_screen.dart';
import '../../home/data/model/category_model.dart';
import '../../notifications/view/notification_screen.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final int? categoryId;

  const CategoryDetailsScreen({super.key, required this.categoryId});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
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
      backgroundColor: AppColors.lightGrey,
      body: SafeArea(
        child: BlocProvider(
          create: (context) => HomeCubit()..fetchProducts(isRefresh: true),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final cubit = context.read<HomeCubit>();
              final products = cubit.products;
              final category = cubit.categories.firstWhere(
                (cat) => cat.id == widget.categoryId,
                orElse: () =>
                    CategoryModel(id: widget.categoryId ?? 0, name: 'Unknown'),
              );

              if (state is HomeProductsLoading && products.isEmpty) {
                return const Center(child: CustomLoadingIndicator());
              }

              return BlocBuilder<GlobalCubit, GlobalState>(
                builder: (context, globalState) {
                  return BlocListener<GlobalCubit, GlobalState>(
                    listener: (context, globalState) {
                      if (globalState is WishlistItemRemovedError) {
                        ErrorMessageHandler.showErrorToast(
                            context, globalState.error);
                      }
                      if (globalState is WishlistItemRemovedSuccess) {
                        showToast(context,
                            message: globalState.message,
                            state: ToastStates.success);
                      }
                    },
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        category.name?.tr(context) ??
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
                                      navigateTo(
                                          context, const NotificationsScreen());
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
                                      navigateTo(context,
                                          const CustomerServiceScreen());
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
                                  onTap: () {
                                    cubit.selectCategory(-1);
                                    cubit.fetchProducts();
                                  },
                                ),
                                SizedBox(width: 10.w),
                                CategoryChip(
                                  label: 'featured'.tr(context),
                                  onTap: () {
                                    // Add logic for featured products
                                  },
                                ),
                                SizedBox(width: 10.w),
                                CategoryChip(
                                  label: 'new'.tr(context),
                                  onTap: () {
                                    // Add logic for new products
                                  },
                                ),
                                SizedBox(width: 10.w),
                                CategoryChip(
                                  label: 'popular'.tr(context),
                                  onTap: () {
                                    // Add logic for popular products
                                  },
                                ),
                                SizedBox(width: 20.w),
                              ],
                            ),
                          ),
                          SizedBox(height: 30.h),
                          products.isEmpty
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
                              : Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 15.w,
                                      mainAxisSpacing: 15.h,
                                      childAspectRatio: 0.75,
                                    ),
                                    itemCount: products.length +
                                        (_isLoadingMore ? 1 : 0),
                                    itemBuilder: (context, index) {
                                      if (index >= products.length) {
                                        return const Center(
                                            child: CustomLoadingIndicator());
                                      }
                                      final product = products[index];
                                      return ProductCard(
                                        imageUrl: product.imagePath,
                                        name: product.nameKey,
                                        storeName: product.storeNameKey,
                                        rating: product.rating.isFinite
                                            ? product.rating
                                            : 0.0,
                                        reviewCount: product.reviewCount,
                                        price: product.price.isFinite
                                            ? product.price
                                            : 0.0,
                                        oldPrice: product.oldPrice?.isFinite ==
                                                    true &&
                                                product.oldPrice! > 0
                                            ? product.oldPrice
                                            : null,
                                        isFavorite: product.isFavourited,
                                        onTap: () {
                                          navigateTo(
                                            context,
                                            ProductDetailsScreen(
                                              productId: int.parse(product.id),
                                            ),
                                          );
                                        },
                                        removeFromWishlist: () {
                                          context
                                              .read<GlobalCubit>()
                                              .removeFromWishlist(
                                                int.parse(product.id),
                                              );
                                        },
                                        onFavoriteTap: () {
                                          context
                                              .read<GlobalCubit>()
                                              .addtowishlist(
                                                productId:
                                                    product.id.toString(),
                                              );
                                        },
                                      );
                                    },
                                  ),
                                ),
                          if (_isLoadingMore && cubit.hasMore)
                            SizedBox(
                              height: 50.h,
                              child:
                                  const Center(child: CustomLoadingIndicator()),
                            ),
                          SizedBox(height: 15.h),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
