import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

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
          'about_us'.tr(context),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Logo/Image
            Center(
              child: Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(
                  Icons.store,
                  size: 60.sp,
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(height: 24.h),

            Center(
              child: Text(
                'furniture_store'.tr(context),
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
            ),

            SizedBox(height: 8.h),

            Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textGrey,
                ),
              ),
            ),

            SizedBox(height: 32.h),

            _buildSection(
              'our_story'.tr(context),
              'We are passionate about bringing quality furniture to your home. Founded in 2020, our mission is to make beautiful, comfortable furniture accessible to everyone.',
            ),

            _buildSection(
              'our_mission'.tr(context),
              'To provide high-quality furniture that combines style, comfort, and affordability. We believe everyone deserves a beautiful home.',
            ),

            _buildSection(
              'our_values'.tr(context),
              '• Quality craftsmanship\n• Customer satisfaction\n• Sustainable practices\n• Innovation in design\n• Affordable pricing',
            ),

            SizedBox(height: 24.h),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'contact_information'.tr(context),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _buildContactItem(
                      Icons.email_outlined, 'support@furniturestore.com'),
                  _buildContactItem(Icons.phone_outlined, '+1 (555) 123-4567'),
                  _buildContactItem(Icons.location_on_outlined,
                      '123 Furniture St, Design City, DC 12345'),
                  _buildContactItem(
                      Icons.language_outlined, 'www.furniturestore.com'),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'follow_us'.tr(context),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSocialButton(Icons.facebook, 'Facebook'),
                      _buildSocialButton(Icons.camera_alt, 'Instagram'),
                      _buildSocialButton(Icons.alternate_email, 'Twitter'),
                      _buildSocialButton(Icons.video_library, 'YouTube'),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            Center(
              child: Text(
                '© 2024 Furniture Store. All rights reserved.',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textGrey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            content,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textGrey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20.sp,
            color: AppColors.primary,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String platform) {
    return Column(
      children: [
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Icon(
            icon,
            size: 24.sp,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          platform,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }
}
