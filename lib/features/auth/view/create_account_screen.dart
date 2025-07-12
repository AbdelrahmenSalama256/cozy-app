import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/component/widgets/app_text_field.dart';
import 'package:cozy/core/component/widgets/app_title.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/auth/view/cubit/auth_cubit.dart';
import 'package:cozy/features/auth/view/cubit/auth_state.dart';
import 'package:cozy/features/auth/view/verification_screen.dart';
import 'package:cozy/features/auth/view/widgets/social_login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/component/custom_toast.dart';
import '../../../core/utils/validator.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => AuthCubit(),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthCreateAccountSuccess) {
              showToast(
                context,
                message: state.message.tr(context),
                state: ToastStates.success,
                duration: const Duration(seconds: 3),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<AuthCubit>(),
                    child: VerificationScreen(
                        emailOrPhoneForOtp: state.emailForVerification),
                  ),
                ),
              );
            } else if (state is AuthFailure) {
              showToast(
                context,
                message: state.error.tr(context),
                state: ToastStates.error,
                duration: const Duration(seconds: 3),
              );
            }
          },
          builder: (context, state) {
            final authCubit = context.read<AuthCubit>();
            final formKey = GlobalKey<FormState>();

            return SafeArea(
              child: Column(
                children: [
                  // AppHeader(
                  //   title: "auth_create_account_title".tr(context),
                  //   titleStyle: TextStyle(
                  //       color: AppColors.textBlack,
                  //       fontSize: 18.sp,
                  //       fontWeight: FontWeight.w600),
                  //   showBackButton: true,
                  //   centerTitle: false,
                  // ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.w, vertical: 20.h),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SectionHeader(
                              titleKey: "auth_create_account_title".tr(context),
                              subtitleKey:
                                  "auth_create_account_subtitle".tr(context),
                            ),
                            // Text(
                            //   "auth_create_account_subtitle".tr(context),
                            //   style: TextStyle(
                            //       fontSize: 14.sp, color: AppColors.textGrey),
                            // ),
                            SizedBox(height: 30.h),
                            AppTextField(
                              controller: authCubit.usernameController,
                              labelText: "auth_username_label".tr(context),
                              hintText: "auth_username_hint".tr(context),
                              prefixIcon: Icon(Icons.person_outline,
                                  color: AppColors.textGrey.withOpacity(0.7)),
                              validator: (value) =>
                                  Validators.validateName(value, context),
                            ),
                            SizedBox(height: 20.h),
                            AppTextField(
                              controller:
                                  authCubit.createAccountEmailController,
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
                              controller:
                                  authCubit.createAccountPasswordController,
                              labelText: "auth_password_label".tr(context),
                              hintText: "auth_password_hint".tr(context),
                              prefixIcon: Icon(Icons.lock_outline,
                                  color: AppColors.textGrey.withOpacity(0.7)),
                              obscureText:
                                  authCubit.isConfirmNewPasswordObscure,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  authCubit.isConfirmNewPasswordObscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.textGrey,
                                ),
                                onPressed: () {
                                  authCubit.togglePasswordVisibility(
                                      'createAccount');
                                },
                              ),
                              validator: (value) =>
                                  Validators.validatePassword(value, context),
                            ),
                            SizedBox(height: 30.h),

                            AppButton(
                              text: "onboarding_create_account".tr(context),
                              isLoading: state is AuthLoading,
                              onPressed: () {
                                authCubit.attemptAccountCreation(formKey);
                              },
                            ),
                            SizedBox(height: 30.h),
                            Center(
                              child: Text(
                                "auth_or_sign_up_with".tr(context),
                                style: TextStyle(
                                    fontSize: 13.sp, color: AppColors.textGrey),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            SocialLoginButton(
                              text: "auth_sign_up_google".tr(context),
                              iconAssetPath:
                                  "assets/images/icons/google_logo.png",
                              onPressed: () {},
                            ),
                            SizedBox(height: 16.h),
                            SocialLoginButton(
                              text: "auth_sign_up_facebook".tr(context),
                              iconAssetPath:
                                  "assets/images/icons/facebook_logo.png",
                              onPressed: () {},
                            ),
                            SizedBox(height: 20.h),
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
