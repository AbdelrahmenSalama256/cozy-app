import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/constants/language_switcher.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/auth/view/create_account_screen.dart';
import 'package:cozy/features/auth/view/login_screen.dart';
import 'package:cozy/features/customer_services/view/customer_service_screen.dart';
import 'package:cozy/features/profile/view/about_us_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'addresses_screen.dart';
import 'edit_profile_screen.dart';
import 'my_orders_screen.dart';
import 'notifications_screen.dart';
import 'payment_method_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  bool isLoggedIn = true; // This would come from your auth state management
  late AnimationController _animationController;

  final String userName = "John Doe";
  final String userEmail = "john.doe@example.com";
  final String userPhone = "+1 234 567 8900";
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: SafeArea(
        child: isLoggedIn ? _buildLoggedInProfile() : _buildGuestProfile(),
      ),
    );
  }

  Widget _buildLoggedInProfile() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.r),
                bottomRight: Radius.circular(30.r),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  CircleAvatar(
                    radius: 50.r,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      userName.split(' ').map((e) => e[0]).join(''),
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textGrey,
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // Profile Options
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                _buildProfileOption(
                  icon: Icons.person_outline,
                  title: 'edit_profile'.tr(context),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                ),
                _buildProfileOption(
                  icon: Icons.shopping_bag_outlined,
                  title: 'my_orders'.tr(context),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyOrdersScreen(),
                      ),
                    );
                  },
                ),
                _buildProfileOption(
                  icon: Icons.location_on_outlined,
                  title: 'addresses'.tr(context),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddressesScreen(),
                      ),
                    );
                  },
                ),
                _buildProfileOption(
                  icon: Icons.payment_outlined,
                  title: 'payment_methods'.tr(context),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentMethodsScreen(),
                      ),
                    );
                  },
                ),
                _buildProfileOption(
                  icon: Icons.support_agent_outlined,
                  title: 'customer_service'.tr(context),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CustomerServiceScreen(),
                      ),
                    );
                  },
                ),
                _buildProfileOption(
                  icon: Icons.notifications_outlined,
                  title: 'notifications'.tr(context),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationsScreen(),
                      ),
                    );
                  },
                ),
                _buildProfileOption(
                  icon: Icons.language_outlined,
                  title: 'language'.tr(context),
                  onTap: () {
                    // Replace with the LanguageSwitcher widget
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('select_language'.tr(context)),
                        content: const LanguageSwitcher(),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('close'.tr(context)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                _buildProfileOption(
                  icon: Icons.info_outline,
                  title: 'about_us'.tr(context),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutUsScreen(),
                      ),
                    );
                  },
                ),
                _buildProfileOption(
                  icon: Icons.logout,
                  title: 'logout'.tr(context),
                  onTap: () {
                    _showLogoutDialog();
                  },
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestProfile() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            size: 100.sp,
            color: AppColors.textGrey,
          ),
          SizedBox(height: 24.h),
          Text(
            'welcome_guest'.tr(context),
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'login_to_access_features'.tr(context),
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textGrey,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: AppButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              text: 'login'.tr(context),
            ),
          ),
          SizedBox(height: 16.h),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateAccountScreen(),
                ),
              );
            },
            child: Text(
              'create_account'.tr(context),
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      color: AppColors.white,
      margin: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: isDestructive
                      ? AppColors.error.withOpacity(0.1)
                      : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Icon(
                  icon,
                  color: isDestructive ? AppColors.error : AppColors.primary,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color:
                        isDestructive ? AppColors.error : AppColors.textBlack,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textGrey,
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('logout'.tr(context)),
        content: Text('logout_confirmation'.tr(context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr(context)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                isLoggedIn = false;
              });
            },
            child: Text(
              'logout'.tr(context),
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
