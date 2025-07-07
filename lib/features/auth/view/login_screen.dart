import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/component/widgets/app_text_field.dart';
import 'package:cozy/core/component/widgets/app_title.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/constants/navigation.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/utils/validator.dart';
import 'package:cozy/features/auth/view/create_account_screen.dart';
import 'package:cozy/features/auth/view/cubit/auth_cubit.dart';
import 'package:cozy/features/auth/view/cubit/auth_state.dart';
import 'package:cozy/features/auth/view/widgets/forgot_password_bottom_sheet.dart';
import 'package:cozy/features/auth/view/widgets/social_login_button.dart';
import 'package:cozy/features/home/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => AuthCubit(),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthLoginSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content: Text(state.message.tr(context)),
                    backgroundColor: Colors.green));
              navigateAndFinish(context, HomeScreen());
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content: Text(state.error.tr(context)),
                    backgroundColor: Colors.red));
            }
          },
          builder: (context, state) {
            // 01020697427
            // ando@gmail.com
            // 123456789Aa@
            final authCubit = context.read<AuthCubit>();
            final formKey = GlobalKey<FormState>();

            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.w, vertical: 20.h),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SectionHeader(
                              titleKey: "auth_login_title".tr(context),
                              subtitleKey: "auth_login_subtitle".tr(context),
                            ),
                            SizedBox(height: 30.h),
                            AppTextField(
                              controller: authCubit.loginEmailController,
                              labelText: "auth_email_phone_label".tr(context),
                              hintText: "auth_email_phone_hint".tr(context),
                              prefixIcon: Icon(Icons.email_outlined,
                                  color: AppColors.textGrey.withOpacity(0.7)),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) =>
                                  Validators.validateEmail(value, context),
                            ),
                            SizedBox(height: 20.h),
                            AppTextField(
                              controller: authCubit.loginPasswordController,
                              labelText: "auth_password_label".tr(context),
                              hintText: "auth_password_hint".tr(context),
                              prefixIcon: Icon(Icons.lock_outline,
                                  color: AppColors.textGrey.withOpacity(0.7)),
                              obscureText: authCubit.isLoginPasswordObscure,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  authCubit.isLoginPasswordObscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.textGrey,
                                ),
                                onPressed: () {
                                  authCubit.togglePasswordVisibility('login');
                                },
                              ),
                              validator: (value) =>
                                  Validators.validatePassword(value, context),
                            ),
                            SizedBox(height: 12.h),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) => BlocProvider.value(
                                      value: authCubit,
                                      child: const ForgotPasswordBottomSheet(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "auth_forgot_password_link".tr(context),
                                  style: TextStyle(
                                      color: AppColors.primaryLight,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            if (state is AuthLoading)
                              Center(
                                  child: CircularProgressIndicator(
                                      color: AppColors.primaryLight))
                            else
                              AppButton(
                                text: "auth_sign_in_button".tr(context),
                                onPressed: () {
                                  authCubit.attemptLogin(formKey);
                                },
                                backgroundColor: AppColors.primaryLight,
                              ),
                            SizedBox(height: 30.h),
                            Center(
                              child: Text(
                                "auth_or_sign_in_with".tr(context),
                                style: TextStyle(
                                    fontSize: 13.sp, color: AppColors.textGrey),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            SocialLoginButton(
                              text: "auth_sign_in_google".tr(context),
                              iconAssetPath:
                                  "assets/images/icons/google_logo.png",
                              onPressed: () {},
                            ),
                            SizedBox(height: 16.h),
                            SocialLoginButton(
                              text: "auth_sign_in_facebook".tr(context),
                              iconAssetPath:
                                  "assets/images/icons/facebook_logo.png",
                              onPressed: () {},
                            ),
                            SizedBox(height: 30.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("auth_dont_have_account".tr(context),
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.textGrey)),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => BlocProvider.value(
                                                value: authCubit,
                                                child:
                                                    const CreateAccountScreen())));
                                  },
                                  child: Text(
                                      "onboarding_create_account".tr(context),
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: AppColors.primaryLight,
                                          fontWeight: FontWeight.bold)),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
