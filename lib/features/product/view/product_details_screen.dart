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
import '../data/model/product_details_model.dart';

class ProductDetailsScreen extends StatelessWidget {
  final int productId;
  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..fetchProductDetails(productId),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is ProductDetailsError) {
              ErrorMessageHandler.showErrorToast(context, state.message);
            }
          },
          builder: (context, state) {
            final cubit = context.read<HomeCubit>();

            if (state is ProductDetailsLoading ||
                cubit.productDetails.isEmpty) {
              return const Center(child: CustomLoadingIndicator());
            }

            if (state is ProductDetailsError) {
              return _buildErrorState(context, cubit);
            }

            final product = cubit.productDetails.last;
            return _ProductDetailsContent(
              product: product,
              productId: productId,
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, HomeCubit cubit) {
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
              cubit.fetchProductDetails(productId);
            },
            type: AppButtonType.primary,
          ),
        ],
      ),
    );
  }
}

class _ProductDetailsContent extends StatelessWidget {
  final ProductDetailsModel product;
  final int productId;

  const _ProductDetailsContent({
    required this.product,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    context.read<HomeCubit>();
    final hasVariations = product.variations?.isNotEmpty ?? false;
    final imageUrls = product.imageUrls ?? [product.imageUrl ?? ''];

    return BlocConsumer<GlobalCubit, GlobalState>(
      listener: (context, globalState) {
        if (globalState is WishlistError) {
          ErrorMessageHandler.showErrorToast(context, globalState.message);
        } else if (globalState is WishlistSuccess) {
          showToast(
            context,
            message: globalState.message.tr(context),
            state: ToastStates.success,
            duration: const Duration(seconds: 3),
          );
        }
        if (globalState is CartError) {
          ErrorMessageHandler.showErrorToast(context, globalState.error);
        } else if (globalState is CartLoaded) {
          showToast(
            context,
            message: 'product_added_successfully'.tr(context),
            state: ToastStates.success,
            duration: const Duration(seconds: 3),
          );
        }
      },
      builder: (context, globalState) {
        return CustomScrollView(
          slivers: [
            _ProductImagesSection(imageUrls: imageUrls),
            _ProductInfoSection(
              product: product,
              productId: productId,
              hasVariations: hasVariations,
              globalState: globalState,
            ),
          ],
        );
      },
    );
  }
}

class _ProductImagesSection extends StatelessWidget {
  final List<String> imageUrls;

  const _ProductImagesSection({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
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
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final product = context.read<HomeCubit>().productDetails.last;
            return IconButton(
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
              },
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: imageUrls.isNotEmpty
            ? _ProductImageCarousel(imageUrls: imageUrls)
            : Container(
                color: AppColors.lightGrey,
                child: const Icon(Icons.image_not_supported),
              ),
      ),
    );
  }
}

class _ProductImageCarousel extends StatefulWidget {
  final List<String> imageUrls;

  const _ProductImageCarousel({required this.imageUrls});

  @override
  __ProductImageCarouselState createState() => __ProductImageCarouselState();
}

class __ProductImageCarouselState extends State<_ProductImageCarousel> {
  int currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: widget.imageUrls.length,
      onPageChanged: (index) => setState(() => currentImageIndex = index),
      itemBuilder: (context, index) => Image.network(
        widget.imageUrls[index],
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: AppColors.lightGrey,
          child: const Icon(Icons.image_not_supported),
        ),
      ),
    );
  }
}

class _ProductInfoSection extends StatelessWidget {
  final ProductDetailsModel product;
  final int productId;
  final bool hasVariations;
  final GlobalState globalState;

  const _ProductInfoSection({
    required this.product,
    required this.productId,
    required this.hasVariations,
    required this.globalState,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProductNameAndStore(product: product),
              SizedBox(height: 16.h),
              _PriceDisplay(product: product, hasVariations: hasVariations),
              SizedBox(height: 24.h),
              if (product.description?.isNotEmpty ?? false) ...[
                _DescriptionSection(description: product.description!),
                SizedBox(height: 24.h),
              ],
              if (product.specifications?.isNotEmpty ?? false) ...[
                _SpecificationsSection(specifications: product.specifications!),
                SizedBox(height: 24.h),
              ],
              if (hasVariations)
                _VariationsSection(variations: product.variations!),
              _QuantitySelector(hasVariations: hasVariations, product: product),
              SizedBox(height: 24.h),
              _ActionButtons(
                productId: productId,
                hasVariations: hasVariations,
                globalState: globalState,
                product: product,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductNameAndStore extends StatelessWidget {
  final ProductDetailsModel product;

  const _ProductNameAndStore({required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name?.tr(context) ?? 'No Name',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          product.storeName?.tr(context) ?? 'Unknown Store',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }
}

class _PriceDisplay extends StatelessWidget {
  final ProductDetailsModel product;
  final bool hasVariations;

  const _PriceDisplay({
    required this.product,
    required this.hasVariations,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final selectedVariationId = cubit.selectedVariationId;
    final selectedVariation = hasVariations
        ? product.variations?.firstWhere(
            (v) => v.id?.toString() == selectedVariationId,
            orElse: () => product.variations!.first,
          )
        : null;

    final displayPrice = selectedVariation?.price ?? product.price ?? 0.0;

    return Row(
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
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  final String description;

  const _DescriptionSection({required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'description'.tr(context),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          description,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textGrey,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _SpecificationsSection extends StatelessWidget {
  final Map<String, String> specifications;

  const _SpecificationsSection({required this.specifications});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'specifications'.tr(context),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        ...specifications.entries.map((entry) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

class _VariationsSection extends StatelessWidget {
  final List<ProductVariation> variations;

  const _VariationsSection({required this.variations});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final selectedVariationId = cubit.selectedVariationId;
    final selectedVariation = variations.firstWhere(
      (v) => v.id?.toString() == selectedVariationId,
      orElse: () => variations.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          children: variations.map((variation) {
            final isSelected = variation.id?.toString() == selectedVariationId;
            return GestureDetector(
              onTap: () =>
                  cubit.selectVariation(variation.id?.toString() ?? ''),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.textGrey,
                  ),
                ),
                child: Text(
                  '${variation.name ?? 'Variation'} (${variation.price?.toStringAsFixed(2) ?? '0.00'})',
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textBlack,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 16.h),
        Text(
          '${'available'.tr(context)}: ${selectedVariation.quantity ?? 0}',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textGrey,
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  final bool hasVariations;
  final ProductDetailsModel product;

  const _QuantitySelector({
    required this.hasVariations,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final selectedVariationId = cubit.selectedVariationId;
    final selectedVariation = hasVariations
        ? product.variations?.firstWhere(
            (v) => v.id?.toString() == selectedVariationId,
            orElse: () => product.variations!.first,
          )
        : null;

    final availableQuantity = selectedVariation?.quantity ?? 0;
    final quantity = cubit.quantity;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                if (quantity > 1) {
                  cubit.updateQuantity(quantity - 1);
                }
              },
            ),
            Text(
              '$quantity',
              style: TextStyle(fontSize: 16.sp),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                if (quantity < availableQuantity) {
                  cubit.updateQuantity(quantity + 1);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final int productId;
  final bool hasVariations;
  final GlobalState globalState;
  final ProductDetailsModel product;

  const _ActionButtons({
    required this.productId,
    required this.hasVariations,
    required this.globalState,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final selectedVariationId = cubit.selectedVariationId;
    final quantity = cubit.quantity;

    return Container(
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
                if (selectedVariationId.isEmpty && hasVariations) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select a variation'.tr(context)),
                    ),
                  );
                  return;
                }
                final variationId = selectedVariationId.isEmpty
                    ? productId.toString()
                    : selectedVariationId;
                context.read<GlobalCubit>().addToCart(
                      productId: productId.toString(),
                      quantity: quantity,
                      variation: int.tryParse(variationId) ?? productId,
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
    );
  }
}
