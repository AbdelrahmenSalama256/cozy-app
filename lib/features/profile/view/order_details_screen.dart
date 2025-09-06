import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/component/widgets/app_button.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  // Fake order data
  final String orderId = 'ORD123456';
  final DateTime orderDate = DateTime(2025, 7, 10);
  final String statusText =
      'processing'; // Changed to processing for cancellation UI
  final Color statusColor =
      AppColors.warning; // Assuming warning for processing
  final String? trackingNumber = null; // No tracking number for processing

  // Fake order items data
  final List<OrderItemModel> orderItems = [
    OrderItemModel(
      id: '1',
      nameKey: 'item_name_headphones',
      image: 'https://via.placeholder.com/80x80?text=Headphones',
      price: 149.99,
      quantity: 1,
      color: 'color_black',
      size: 'size_one_size',
    ),
    OrderItemModel(
      id: '2',
      nameKey: 'item_name_smart_watch',
      image: 'https://via.placeholder.com/80x80?text=Smart+Watch',
      price: 399.99,
      quantity: 1,
      color: 'color_silver',
      size: 'size_42mm',
    ),
  ];

  // Fake shipping address data
  final String shippingName = 'John Doe';
  final String shippingAddress = 'address_details';
  final String shippingPhone = '+1 (555) 123-4567';

  // Fake payment method data
  final String paymentMethod = 'payment_visa';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textBlack, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${'order'.tr(context)} #$orderId',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: AppColors.textBlack, size: 20.sp),
            onPressed: () {
              // Share order details (placeholder)
              if (kDebugMode) {
                print('Share order #$orderId');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildOrderStatusCard(),
            SizedBox(height: 16.h),
            _buildOrderItemsList(),
            SizedBox(height: 16.h),
            _buildShippingAddressCard(),
            SizedBox(height: 16.h),
            _buildPaymentMethodCard(),
            SizedBox(height: 16.h),
            _buildOrderSummaryCard(),
            SizedBox(height: 16.h),
            _buildActionButtons(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatusCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  statusText.tr(context),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(orderDate),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemsList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              'order_items'.tr(context),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlack,
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderItems.length,
            separatorBuilder: (context, index) => Divider(
              height: 1.h,
              color: AppColors.lightGrey,
            ),
            itemBuilder: (context, index) {
              final item = orderItems[index];
              return _buildOrderItem(item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(OrderItemModel item) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                item.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.image,
                    color: AppColors.textGrey,
                    size: 30.sp,
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nameKey.tr(context),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                if (item.color != null || item.size != null) ...[
                  Text(
                    '${item.color?.tr(context) ?? ''} ${item.size?.tr(context) ?? ''}'
                        .trim(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textGrey,
                    ),
                  ),
                  SizedBox(height: 4.h),
                ],
                Row(
                  children: [
                    Text(
                      '${'qty'.tr(context)}: ${item.quantity}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textGrey,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingAddressCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 20.sp,
                color: AppColors.primary,
              ),
              SizedBox(width: 8.w),
              Text(
                'shipping_address'.tr(context),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            shippingName,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            shippingAddress.tr(context),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textGrey,
              height: 1.4,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            shippingPhone,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.payment,
                size: 20.sp,
                color: AppColors.primary,
              ),
              SizedBox(width: 8.w),
              Text(
                'payment_method'.tr(context),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Container(
                width: 40.w,
                height: 25.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Center(
                  child: Text(
                    paymentMethod.tr(context),
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                '**** **** **** 1234',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
    final subtotal = orderItems.fold<double>(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    final shipping = 9.99;
    final tax = subtotal * 0.08;
    final total = subtotal + shipping + tax;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'order_summary'.tr(context),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 16.h),
          _buildSummaryRow('subtotal'.tr(context), subtotal),
          SizedBox(height: 8.h),
          _buildSummaryRow('shipping'.tr(context), shipping),
          SizedBox(height: 8.h),
          _buildSummaryRow('tax'.tr(context), tax),
          SizedBox(height: 12.h),
          Divider(color: AppColors.lightGrey),
          SizedBox(height: 12.h),
          Row(
            children: [
              Text(
                'total'.tr(context),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              const Spacer(),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textGrey,
          ),
        ),
        const Spacer(),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textBlack,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          if (statusText == 'processing') ...[
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: 'cancel_order'.tr(context),
                onPressed: () {
                  _showCancelOrderDialog();
                },
                type: AppButtonType.secondary,
                height: 48.h,
                borderRadius: BorderRadius.circular(4.r),
                borderColor: Colors.red,
                textStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ),
            SizedBox(height: 12.h),
          ],
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'contact_support'.tr(context),
                  onPressed: () {
                    // Contact support (placeholder)
                    if (kDebugMode) {
                      print('Contact support for order #$orderId');
                    }
                  },
                  type: AppButtonType.secondary,
                  height: 48.h,
                  borderRadius: BorderRadius.circular(4.r),
                  borderColor: AppColors.primary,
                  textStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: AppButton(
                  text: 'reorder'.tr(context),
                  onPressed: () {
                    // Reorder (placeholder)
                    if (kDebugMode) {
                      print('Reorder #$orderId');
                    }
                  },
                  type: AppButtonType.primary,
                  height: 48.h,
                  borderRadius: BorderRadius.circular(4.r),
                  backgroundColor: AppColors.primary,
                  textStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCancelOrderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
          title: Text(
            'cancel_order'.tr(context),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
          ),
          content: Text(
            'are_you_sure_cancel_order'.tr(context),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textGrey,
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'no'.tr(context),
                    onPressed: () => Navigator.pop(context),
                    type: AppButtonType.secondary,
                    height: 36.h,
                    borderRadius: BorderRadius.circular(8.r),
                    borderColor: AppColors.textGrey,
                    textStyle: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textGrey,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.h,
                ),
                Expanded(
                  child: AppButton(
                    text: 'yes_cancel'.tr(context),
                    onPressed: () {
                      Navigator.pop(context);
                      // Handle order cancellation (placeholder)
                      if (kDebugMode) {
                        print('Cancel order #$orderId');
                      }
                    },
                    type: AppButtonType.primary,
                    height: 36.h,
                    borderRadius: BorderRadius.circular(8.r),
                    backgroundColor: Colors.red,
                    textStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Order Item Model
class OrderItemModel {
  final String id;
  final String nameKey; // Changed to nameKey for localization
  final String image;
  final double price;
  final int quantity;
  final String? color;
  final String? size;

  OrderItemModel({
    required this.id,
    required this.nameKey,
    required this.image,
    required this.price,
    required this.quantity,
    this.color,
    this.size,
  });
}
