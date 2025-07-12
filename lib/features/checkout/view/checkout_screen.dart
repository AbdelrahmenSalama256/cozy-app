import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/cart/data/model/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/models/address_model.dart';
import '../data/models/payment_method.dart';
import 'order_success_screen.dart';
import 'widgets/address_card.dart';
import 'widgets/checkout_bottom_section.dart';
import 'widgets/order_notes.dart';
import 'widgets/order_summary.dart';
import 'widgets/payment_card.dart';
import 'widgets/section_container.dart';

class CheckoutScreen extends StatefulWidget {
  final Cart cart;

  const CheckoutScreen({super.key, required this.cart});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int selectedAddressIndex = 0;
  int selectedPaymentIndex = 0;
  bool isProcessing = false;

  final List<Address> addresses = [
    Address(
      id: '1',
      title: 'Home',
      address: '123 Main Street, Apt 4B',
      city: 'New York, NY 10001',
      isDefault: true,
    ),
    Address(
      id: '2',
      title: 'Work',
      address: '456 Business Ave, Suite 200',
      city: 'New York, NY 10002',
      isDefault: false,
    ),
  ];

  final List<PaymentMethod> paymentMethods = [
    PaymentMethod(
      id: '1',
      type: 'Credit Card',
      details: '**** **** **** 1234',
      icon: Icons.credit_card,
      isDefault: true,
    ),
    PaymentMethod(
      id: '2',
      type: 'PayPal',
      details: 'john.doe@email.com',
      icon: Icons.account_balance_wallet,
      isDefault: false,
    ),
    PaymentMethod(
      id: '3',
      type: 'Apple Pay',
      details: 'Touch ID',
      icon: Icons.phone_iphone,
      isDefault: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.textBlack,
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'checkout'.tr(context),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // Order Summary
                  OrderSummarySection(cart: widget.cart),

                  SizedBox(height: 20.h),

                  // Delivery Address
                  SectionContainer(
                    title: 'delivery_address'.tr(context),
                    actionText: 'change'.tr(context),
                    onActionPressed: _showAddressSelection,
                    child: AddressCard(
                      address: addresses[selectedAddressIndex],
                      isSelected: true,
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Payment Method
                  SectionContainer(
                    title: 'payment_method'.tr(context),
                    actionText: 'change'.tr(context),
                    onActionPressed: _showPaymentSelection,
                    child: PaymentCard(
                      payment: paymentMethods[selectedPaymentIndex],
                      isSelected: true,
                    ),
                  ),

                  // SizedBox(height: 20.h),

                  // Delivery Options
                  // DeliveryOptionsSection(),

                  SizedBox(height: 20.h),

                  // Order Notes
                  OrderNotesSection(),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          // Bottom Section with Total and Place Order
          CheckoutBottomSection(
            total: widget.cart.total,
            isProcessing: isProcessing,
            onPlaceOrder: _placeOrder,
          ),
        ],
      ),
    );
  }

  void _showAddressSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'select_address'.tr(context),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            ...addresses.asMap().entries.map((entry) {
              int index = entry.key;
              Address address = entry.value;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAddressIndex = index;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  child: AddressCard(
                    address: address,
                    isSelected: index == selectedAddressIndex,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showPaymentSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'select_payment_method'.tr(context),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            ...paymentMethods.asMap().entries.map((entry) {
              int index = entry.key;
              PaymentMethod payment = entry.value;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedPaymentIndex = index;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  child: PaymentCard(
                    payment: payment,
                    isSelected: index == selectedPaymentIndex,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _placeOrder() async {
    setState(() {
      isProcessing = true;
    });

    // Simulate order processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isProcessing = false;
    });

    // Navigate to success screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSuccessScreen(
          orderNumber: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
          total: widget.cart.total,
        ),
      ),
    );
  }
}
