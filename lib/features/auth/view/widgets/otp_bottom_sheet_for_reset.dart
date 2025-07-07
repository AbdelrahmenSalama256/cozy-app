import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/utils/validator.dart';
import 'package:cozy/features/auth/view/cubit/auth_cubit.dart';
import 'package:cozy/features/auth/view/cubit/auth_state.dart';
import 'package:cozy/features/auth/view/widgets/create_new_password_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class OtpBottomSheetForReset extends StatelessWidget {
  final String emailOrPhoneForOtp;
  const OtpBottomSheetForReset({super.key, required this.emailOrPhoneForOtp});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final formKey = GlobalKey<FormState>();

    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 60.h,
      textStyle: TextStyle(
          fontSize: 22.sp,
          color: AppColors.textBlack,
          fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        color: AppColors.inputFieldBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.transparent),
      ),
    );

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthOtpVerificationSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text(state.message.tr(context)),
                backgroundColor: Colors.green));
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => BlocProvider.value(
              value: authCubit,
              child: const CreateNewPasswordBottomSheet(),
            ),
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text(state.error.tr(context)),
                backgroundColor: Colors.red));
        }
      },
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: AppColors.textGrey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "auth_verification_code_label".tr(context),
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "auth_verification_message".tr(context),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.sp, color: AppColors.textGrey),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        emailOrPhoneForOtp,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.sp, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Pinput(
                    controller: authCubit.otpController,
                    length: 4,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyDecorationWith(
                      border:
                          Border.all(color: AppColors.primaryLight, width: 2),
                    ),
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    validator: (value) =>
                        Validators.validateOtp(value, context),
                  ),
                  SizedBox(height: 24.h),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return Center(
                            child: CircularProgressIndicator(
                                color: AppColors.primaryLight));
                      }
                      return AppButton(
                        text: "auth_submit_button".tr(context),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            authCubit.verifyResetOtpAndShowCreateNewPassword();
                          }
                        },
                        backgroundColor: AppColors.primaryLight,
                      );
                    },
                  ),
                  SizedBox(height: 16.h),
                  TextButton(
                    onPressed: () {
                      authCubit.sendForgotPasswordCode(formKey);
                    },
                    child: Text("auth_resend_code".tr(context),
                        style: TextStyle(
                            color: AppColors.primaryLight, fontSize: 14.sp)),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
