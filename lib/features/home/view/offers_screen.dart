import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OffersScreen extends StatelessWidget {
  final List<Map<String, dynamic>> demoOffers = [
    {
      'title': 'Summer Sale',
      'description': 'Get amazing discounts on all furniture',
      'discount': 50,
      'code': 'SUMMER50',
      'expiry': '2023-08-31',
      'isExpiringSoon': false,
      'image':
          'assets/images/furniture-styles-GettyImages-1467984982-512fed4077b646eabbc187619554d517.jpg',
    },
    {
      'title': 'New Customer Offer',
      'description': 'Special discount for first-time buyers',
      'discount': 30,
      'code': 'NEW30',
      'expiry': '2023-08-15',
      'isExpiringSoon': true,
      'image':
          'assets/images/furniture-styles-GettyImages-1467984982-512fed4077b646eabbc187619554d517.jpg',
    },
    {
      'title': 'Clearance Sale',
      'description': 'Limited time offer on selected items',
      'discount': 40,
      'code': 'CLEAR40',
      'expiry': '2023-09-10',
      'isExpiringSoon': false,
      'image':
          'assets/images/furniture-styles-GettyImages-1467984982-512fed4077b646eabbc187619554d517.jpg',
    },
    {
      'title': 'Weekend Special',
      'description': 'Weekend exclusive discounts',
      'discount': 25,
      'code': 'WEEKEND25',
      'expiry': '2023-08-13',
      'isExpiringSoon': true,
      'image':
          'assets/images/furniture-styles-GettyImages-1467984982-512fed4077b646eabbc187619554d517.jpg',
    },
  ];

  OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'offers'.tr(context),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
      ),
      body: demoOffers.isEmpty
          ? _buildEmptyState(context)
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBanner(context),
                  SizedBox(height: 24.h),
                  _buildCurrentOffers(context),
                  SizedBox(height: 24.h),
                  _buildExpiringSoon(context),
                ],
              ),
            ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Container(
        height: 150.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryLight],
          ),
        ),
        child: Stack(
          children: [
            PositionedDirectional(
              start: 20.w,
              top: 20.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            PositionedDirectional(
              start: -20.w,
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
    );
  }

  Widget _buildCurrentOffers(BuildContext context) {
    final currentOffers =
        demoOffers.where((offer) => !offer['isExpiringSoon']).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'current_offers'.tr(context),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              Text(
                'view_all_offers'.tr(context),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          currentOffers.isEmpty
              ? _buildNoOffers(context)
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: currentOffers.length,
                  itemBuilder: (context, index) {
                    final offer = currentOffers[index];
                    return _buildOfferCard(context, offer);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildExpiringSoon(BuildContext context) {
    final expiringOffers =
        demoOffers.where((offer) => offer['isExpiringSoon']).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'expiring_soon'.tr(context),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 16.h),
          expiringOffers.isEmpty
              ? _buildNoOffers(context)
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: expiringOffers.length,
                  itemBuilder: (context, index) {
                    final offer = expiringOffers[index];
                    return _buildOfferCard(context, offer, isExpiring: true);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(BuildContext context, Map<String, dynamic> offer,
      {bool isExpiring = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: Image.asset(
              offer['image'],
              height: 120.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      offer['title'],
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: isExpiring
                            ? AppColors.error.withOpacity(0.1)
                            : AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        '${offer['discount']}${'discount'.tr(context)}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color:
                              isExpiring ? AppColors.error : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  offer['description'],
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textGrey,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${'valid_until'.tr(context)} ${offer['expiry']}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textGrey,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${'use_code'.tr(context)} ${offer['code']}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'apply'.tr(context),
                        style: TextStyle(
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
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_offer_outlined,
            size: 60.sp,
            color: AppColors.textGrey,
          ),
          SizedBox(height: 16.h),
          Text(
            'no_offers'.tr(context),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'check_back'.tr(context),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoOffers(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_offer_outlined,
            size: 40.sp,
            color: AppColors.textGrey,
          ),
          SizedBox(height: 8.h),
          Text(
            'no_offers_section'.tr(context),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'check_back_section'.tr(context),
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}
