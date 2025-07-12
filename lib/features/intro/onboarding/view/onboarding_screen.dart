import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/auth/view/create_account_screen.dart';
import 'package:cozy/features/auth/view/login_screen.dart';
import 'package:cozy/features/intro/onboarding/data/model/onboarding_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutCubic));
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with decorative shapes
          _buildBackgroundShapes(),

          SafeArea(
            child: Column(
              children: [
                // Custom header with skip button
                _buildHeader(),

                // Main content area
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: onboardingContents.length,
                    onPageChanged: (int page) {
                      setState(() {});
                      _animationController.reset();
                      _animationController.forward();
                    },
                    itemBuilder: (_, i) {
                      return _buildOnboardingPage(i);
                    },
                  ),
                ),

                // Bottom section with indicators and buttons
                _buildBottomSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundShapes() {
    return Stack(
      children: [
        // Gradient background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.white,
                AppColors.primaryLight.withOpacity(0.05),
                AppColors.white,
              ],
            ),
          ),
        ),

        // Top decorative shapes
        Positioned(
          top: -50.h,
          right: -30.w,
          child: Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLight.withOpacity(0.1),
            ),
          ),
        ),

        Positioned(
          top: 100.h,
          left: -40.w,
          child: Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: AppColors.primary.withOpacity(0.08),
            ),
          ),
        ),

        // Bottom decorative shapes
        Positioned(
          bottom: 200.h,
          right: -20.w,
          child: Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: AppColors.primaryLight.withOpacity(0.12),
            ),
          ),
        ),

        Positioned(
          bottom: 100.h,
          left: -25.w,
          child: Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.06),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo or brand name
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.chair_outlined,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'cozy_home'.tr(context),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          // Skip button with modern design
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
                if (kDebugMode) {
                  print("Navigate to Login via Skip");
                }
              },
              child: Text(
                "onboarding_skip".tr(context),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.primaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40.h),

                    // Creative image container with shapes
                    _buildImageContainer(index),

                    SizedBox(height: 40.h),

                    // Title with creative styling
                    _buildTitle(index),

                    SizedBox(height: 16.h),

                    // Description with better typography
                    _buildDescription(index),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageContainer(int index) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background decorative shape
        Container(
          width: 280.w,
          height: 280.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.primaryLight.withOpacity(0.1),
                AppColors.primary.withOpacity(0.05),
                Colors.transparent,
              ],
            ),
          ),
        ),

        // Secondary decorative shape
        Container(
          width: 240.w,
          height: 240.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60.r),
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 20.r,
                offset: Offset(0, 10.h),
              ),
            ],
          ),
        ),

        // Main image container
        Container(
          width: 220.w,
          height: 220.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.lightGrey.withOpacity(0.3),
                AppColors.lightGrey,
              ],
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50.r),
            child: Image.network(
              onboardingContents[index].imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Icon(
                  Icons.chair_outlined,
                  size: 80.sp,
                  color: AppColors.primary.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ),

        // Floating decorative elements
        Positioned(
          top: 20.h,
          right: 20.w,
          child: Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLight.withOpacity(0.6),
            ),
          ),
        ),

        Positioned(
          bottom: 30.h,
          left: 30.w,
          child: Container(
            width: 16.w,
            height: 16.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              color: AppColors.primary.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        onboardingContents[index].title(context),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textBlack,
          height: 1.3,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  Widget _buildDescription(int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Text(
        onboardingContents[index].description(context),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16.sp,
          color: AppColors.textGrey,
          height: 1.6,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.textGrey.withOpacity(0.1),
            blurRadius: 10.r,
            offset: Offset(0, -5.h),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Custom page indicator
          _buildCustomPageIndicator(),

          SizedBox(height: 32.h),

          // Action buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildCustomPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        onboardingContents.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: _pageController.hasClients &&
                  _pageController.page?.round() == index
              ? 24.w
              : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            color: _pageController.hasClients &&
                    _pageController.page?.round() == index
                ? AppColors.primary
                : AppColors.primaryLight.withOpacity(0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Create Account Button with gradient
        Container(
          width: double.infinity,
          height: 56.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 12.r,
                offset: Offset(0, 6.h),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16.r),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateAccountScreen(),
                  ),
                );
                if (kDebugMode) {
                  print("Navigate to Create Account");
                }
              },
              child: Center(
                child: Text(
                  "onboarding_create_account".tr(context),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: 16.h),

        // Login text with modern styling
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
            if (kDebugMode) {
              print("Navigate to Login");
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 15.sp,
                  color: AppColors.textGrey,
                  fontFamily: context.read<GlobalCubit>().language == "ar"
                      ? 'Tajawal'
                      : "Poppins",
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "onboarding_already_have_account".tr(context),
                  ),
                  TextSpan(
                    text: ' ${"onboarding_login".tr(context)}',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primary.withOpacity(0.5),
                      fontFamily: context.read<GlobalCubit>().language == "ar"
                          ? 'Tajawal'
                          : "Poppins",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
