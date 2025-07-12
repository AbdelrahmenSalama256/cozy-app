import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/constants/navigation.dart';
import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/cart/view/cubit/cart_cubit.dart';
import 'package:cozy/features/cart/view/widgets/cart_item_card.dart';
import 'package:cozy/features/checkout/view/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'cubit/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit(),
      child: Scaffold(
        backgroundColor: AppColors.lightGrey,
        body: SafeArea(
          child: BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              final cubit = context.read<CartCubit>();
              return Stack(
                children: [
                  _buildCartContent(context, cubit),
                  _buildShippingSheet(context, cubit),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartCubit cubit) {
    if (cubit.cart.isEmpty) {
      return _buildEmptyCart(context);
    }

    return Column(
      children: [
        // Header
        Padding(
          padding: EdgeInsets.all(20.w),
          child: Row(
            children: [
              Text(
                'cart'.tr(context),
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              const Spacer(),
              Text(
                '${cubit.cart.totalItems} ${'items'.tr(context)}',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
        ),

        // Cart Items
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: cubit.cart.items.length,
            itemBuilder: (context, index) {
              final cartItem = cubit.cart.items[index];
              return CartItemCard(
                key: ValueKey(cartItem.id), // Ensure unique key for each item
                cartItem: cartItem,
                onQuantityChanged: (newQuantity) {
                  cubit.updateCartItemQuantity(cartItem.id, newQuantity);
                },
                onRemove: () {
                  cubit.removeFromCart(cartItem.id);
                },
              );
            },
          ),
        ),

        // Order Summary
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSummaryRow(
                  context, 'subtotal'.tr(context), cubit.cart.subtotal),
              GestureDetector(
                onTap: () {
                  _showShippingSheet(context, cubit);
                },
                child: _buildSummaryRow(
                    context, 'shipping'.tr(context), cubit.cart.shipping,
                    isInteractive: true),
              ),
              _buildSummaryRow(context, 'tax'.tr(context), cubit.cart.tax),
              Divider(height: 20.h),
              _buildSummaryRow(context, 'total'.tr(context), cubit.cart.total,
                  isTotal: true),
              SizedBox(height: 20.h),
              AppButton(
                text: 'checkout'.tr(context),
                onPressed: () {
                  navigateTo(context, CheckoutScreen(cart: cubit.cart));
                },
                type: AppButtonType.primary,
              ),
              SizedBox(
                height: 50.h,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w), // Added padding
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 100.sp,
              color: AppColors.textGrey,
            ),
            SizedBox(height: 24.h),
            Text(
              'empty_cart'.tr(context),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'empty_cart_message'.tr(context),
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textGrey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            AppButton(
              text: 'start_shopping'.tr(context),
              onPressed: () {
                context.read<GlobalCubit>().changeBottomNavIndex(0);
              },
              type: AppButtonType.primary,
              height: 50.h,
              borderRadius: BorderRadius.circular(25.r),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, double amount,
      {bool isTotal = false, bool isInteractive = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: GestureDetector(
        onTap: isInteractive
            ? () => _showShippingSheet(context, context.read<CartCubit>())
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: isTotal ? 18.sp : 16.sp,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isInteractive ? AppColors.primary : AppColors.textBlack,
              ),
            ),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: isTotal ? 18.sp : 16.sp,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isTotal
                    ? AppColors.primary
                    : (isInteractive ? AppColors.primary : AppColors.textBlack),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showShippingSheet(BuildContext context, CartCubit cubit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.2,
        maxChildSize: 0.8,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: EdgeInsets.only(top: 8.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.textGrey,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'shipping_information'.tr(context),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Cost: \$${cubit.cart.shipping.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textBlack,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Estimated Delivery: 3-5 business days',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textGrey,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Shipping Method: Standard Shipping',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShippingSheet(BuildContext context, CartCubit cubit) {
    return DraggableScrollableSheet(
      initialChildSize: 0.0, // Hidden by default
      minChildSize: 0.0,
      maxChildSize: 0.8,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            // Handle (visible when expanded)
            Container(
              margin: EdgeInsets.only(top: 8.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.textGrey,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'shipping_information'.tr(context),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Cost: \$${cubit.cart.shipping.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.textBlack,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Estimated Delivery: 3-5 business days',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textGrey,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Shipping Method: Standard Shipping',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
