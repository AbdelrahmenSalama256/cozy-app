import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/home/view/cubit/home_cubit.dart';
import 'package:cozy/features/home/view/cubit/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/component/custom_loading_indicator.dart';
import '../../../core/component/custom_toast.dart';
import '../../../core/component/widgets/app_button.dart';
import '../../../core/component/widgets/error_message_handler.dart';
import '../../../core/cubit/global_state.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;
  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _currentImageIndex = 0;
  int _quantity = 1;
  String _selectedVariationId = '';

  void _selectVariation(String variationId) {
    setState(() {
      _selectedVariationId = variationId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => HomeCubit()..fetchProductDetails(widget.productId),
        child: BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
          final cubit = context.read<HomeCubit>();

          // Check if productDetails is empty or loading
          if (state is ProductDetailsLoading || cubit.productDetails.isEmpty) {
            return const Center(child: CustomLoadingIndicator());
          }

          // Check if there's an error state
          if (state is ProductDetailsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.w,
                    color: AppColors.error,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'error_loading_product'.tr(context),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.textGrey,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  AppButton(
                    text: 'retry'.tr(context),
                    onPressed: () {
                      cubit.fetchProductDetails(widget.productId);
                    },
                    type: AppButtonType.primary,
                  ),
                ],
              ),
            );
          }

          final product = cubit.productDetails.last;
          final hasVariations = product.variations?.isNotEmpty ?? false;
          final imageUrls = product.imageUrls ?? [product.imageUrl ?? ''];

          // Set default variation if none selected
          if (_selectedVariationId.isEmpty && hasVariations) {
            _selectedVariationId =
                product.variations?.first.id?.toString() ?? '';
          }

          final selectedVariation = hasVariations
              ? product.variations?.firstWhere(
                  (v) => v.id?.toString() == _selectedVariationId,
                  orElse: () => product.variations!.first,
                )
              : null;

          final displayPrice = selectedVariation?.price ?? product.price ?? 0.0;
          final availableQuantity = selectedVariation?.quantity ?? 0;

          return BlocBuilder<GlobalCubit, GlobalState>(
            builder: (context, globalState) {
              return BlocListener<GlobalCubit, GlobalState>(
                listener: (context, globalState) {
                  if (globalState is WishlistError) {
                    ErrorMessageHandler.showErrorToast(
                        context, globalState.message);
                  } else if (globalState is WishlistSuccess) {
                    showToast(
                      context,
                      message: globalState.message.tr(context),
                      state: ToastStates.success,
                      duration: const Duration(seconds: 3),
                    );
                  }
                  if (globalState is CartError) {
                    ErrorMessageHandler.showErrorToast(
                        context, globalState.error);
                  } else if (globalState is CartLoaded) {
                    showToast(
                      context,
                      message: 'product_added_successfully'.tr(context),
                      state: ToastStates.success,
                      duration: const Duration(seconds: 3),
                    );
                    // navigateTo(context, CartScreen());
                  }
                },
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 400.h,
                      pinned: true,
                      backgroundColor: Colors.white,
                      leading: IconButton(
                        icon: Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: AppColors.textBlack,
                            size: 20.sp,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      actions: [
                        IconButton(
                          icon: Icon(
                            product.isFavourited ?? false
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: (product.isFavourited ?? false)
                                ? AppColors.error
                                : AppColors.textGrey,
                          ),
                          onPressed: () {
                            // Toggle favorite status
                            // context.read<GlobalCubit>().toggleWishlist(
                            //       productId: product.id ?? 0,
                            //     );
                            // cubit.toggleFavoriteStatus();
                          },
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        background: imageUrls.isNotEmpty
                            ? PageView.builder(
                                itemCount: imageUrls.length,
                                onPageChanged: (index) =>
                                    setState(() => _currentImageIndex = index),
                                itemBuilder: (context, index) => Image.network(
                                  imageUrls[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    color: AppColors.lightGrey,
                                    child:
                                        const Icon(Icons.image_not_supported),
                                  ),
                                ),
                              )
                            : Container(
                                color: AppColors.lightGrey,
                                child: const Icon(Icons.image_not_supported),
                              ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30.r)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product name and rating
                              Text(
                                product.name?.tr(context) ?? 'No Name',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 8.h),
                              Text(
                                product.storeName?.tr(context) ??
                                    'Unknown Store',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColors.textGrey,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              // Price display
                              Row(
                                children: [
                                  Text(
                                    displayPrice.toStringAsFixed(2),
                                    style: TextStyle(
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  if (product.oldPrice != null) ...[
                                    SizedBox(width: 12.w),
                                    Text(
                                      product.oldPrice!.toStringAsFixed(2),
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        color: AppColors.textGrey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              SizedBox(height: 24.h),
                              // Description
                              if (product.description?.isNotEmpty ?? false) ...[
                                Text(
                                  'description'.tr(context),
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  product.description ?? '',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.textGrey,
                                    height: 1.5,
                                  ),
                                ),
                                SizedBox(height: 24.h),
                              ],
                              // Specifications
                              if (product.specifications?.isNotEmpty ??
                                  false) ...[
                                Text(
                                  'specifications'.tr(context),
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                ...?product.specifications?.entries
                                    .map((entry) => Padding(
                                          padding: EdgeInsets.only(bottom: 8.h),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 100.w,
                                                child: Text(
                                                  entry.key.tr(context),
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  entry.value,
                                                  style: TextStyle(
                                                      fontSize: 14.sp),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                SizedBox(height: 24.h),
                              ],
                              // Variations section
                              if (hasVariations) ...[
                                Text(
                                  'variations'.tr(context),
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Wrap(
                                  spacing: 8.w,
                                  runSpacing: 8.h,
                                  children:
                                      product.variations!.map((variation) {
                                    final isSelected =
                                        variation.id?.toString() ==
                                            _selectedVariationId;
                                    return GestureDetector(
                                      onTap: () => _selectVariation(
                                          variation.id?.toString() ?? ''),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.w, vertical: 6.h),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.lightGrey,
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                          border: Border.all(
                                            color: isSelected
                                                ? AppColors.primary
                                                : AppColors.textGrey,
                                          ),
                                        ),
                                        child: Text(
                                          '${variation.name ?? 'Variation'} (${variation.price?.toStringAsFixed(2) ?? '0.00'})',
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : AppColors.textBlack,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  '${'available'.tr(context)}: $availableQuantity',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.textGrey,
                                  ),
                                ),
                                SizedBox(height: 24.h),
                              ],
                              // Quantity selector
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'quantity'.tr(context),
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          if (_quantity > 1) {
                                            setState(() => _quantity--);
                                          }
                                        },
                                      ),
                                      Text(
                                        '$_quantity',
                                        style: TextStyle(fontSize: 16.sp),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          if (_quantity < availableQuantity) {
                                            setState(() => _quantity++);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 24.h),
                              // Action buttons
                              Container(
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, -2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: AppButton(
                                        text: 'add_to_cart'.tr(context),
                                        isLoading: globalState is CartLoading,
                                        onPressed: () {
                                          if (_selectedVariationId.isEmpty &&
                                              hasVariations) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Please select a variation'
                                                        .tr(context)),
                                              ),
                                            );
                                            return;
                                          }
                                          final productId =
                                              _selectedVariationId.isEmpty
                                                  ? widget.productId.toString()
                                                  : _selectedVariationId;
                                          context.read<GlobalCubit>().addToCart(
                                                productId:
                                                    "${widget.productId}",
                                                quantity: _quantity,
                                                variation: int.tryParse(
                                                        _selectedVariationId) ??
                                                    widget.productId,
                                              );
                                        },
                                        type: AppButtonType.secondary,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: AppButton(
                                        text: 'buy_now'.tr(context),
                                        onPressed: () {
                                          // Implement buy now functionality
                                        },
                                        type: AppButtonType.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
