import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/auth/view/create_account_screen.dart';
import 'package:cozy/features/auth/view/login_screen.dart';
import 'package:cozy/features/into/onboarding/data/model/onboarding_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              child: Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
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
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingContents.length,
                onPageChanged: (int page) {
                  setState(() {});
                },
                itemBuilder: (_, i) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20.h),
                          Container(
                            height: 250.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey,
                              borderRadius: BorderRadius.circular(16.r),
                              image: DecorationImage(
                                image: NetworkImage(
                                    onboardingContents[i].imagePath),
                                fit: BoxFit.cover,
                                onError: (_, __) => const AssetImage(
                                    'assets/images/fallback_image.png'),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            onboardingContents[i].title(context),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textBlack,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            onboardingContents[i].description(context),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textGrey,
                              height: 1.5.h,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: onboardingContents.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: AppColors.primaryLight,
                  dotColor: AppColors.primaryLight.withOpacity(0.3),
                  dotHeight: 8.h,
                  dotWidth: 8.w,
                  spacing: 6.w,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              child: Column(
                children: [
                  AppButton(
                    text: "onboarding_create_account".tr(context),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CreateAccountScreen()));
                      if (kDebugMode) {
                        print("Navigate to Create Account");
                      }
                    },
                    backgroundColor: AppColors.primaryLight,
                  ),
                  SizedBox(height: 12.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                      if (kDebugMode) {
                        print("Navigate to Login");
                      }
                    },
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textGrey,
                            fontFamily: 'Poppins'),
                        children: <TextSpan>[
                          TextSpan(
                              text: "onboarding_already_have_account"
                                  .tr(context)),
                          TextSpan(
                            text: 'onboarding_login'.tr(context),
                            style: TextStyle(
                                color: AppColors.primaryLight,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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
