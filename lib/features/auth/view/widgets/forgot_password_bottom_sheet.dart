import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/component/widgets/app_text_field.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/utils/validator.dart';
import 'package:cozy/features/auth/view/cubit/auth_cubit.dart';
import 'package:cozy/features/auth/view/cubit/auth_state.dart';
import 'package:cozy/features/auth/view/widgets/otp_bottom_sheet_for_reset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordBottomSheet extends StatelessWidget {
  const ForgotPasswordBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final formKey = GlobalKey<FormState>();

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthForgotPasswordOtpSent) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text(state.message.tr(context)),
                backgroundColor: Colors.blue));
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => BlocProvider.value(
              value: authCubit,
              child: OtpBottomSheetForReset(
                  emailOrPhoneForOtp: state.emailOrPhone),
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    "auth_forgot_password_title".tr(context),
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "auth_forgot_password_sheet_subtitle".tr(context),
                    style:
                        TextStyle(fontSize: 14.sp, color: AppColors.textGrey),
                  ),
                  SizedBox(height: 24.h),
                  AppTextField(
                    controller: authCubit.forgotPasswordEmailController,
                    labelText: "auth_email_phone_label".tr(context),
                    hintText: "auth_email_phone_hint".tr(context),
                    prefixIcon: Icon(Icons.email_outlined,
                        color: AppColors.textGrey.withOpacity(0.7)),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                        Validators.validateEmail(value, context),
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
                        text: "auth_send_code_button".tr(context),
                        onPressed: () {
                          authCubit.sendForgotPasswordCode(formKey);
                        },
                        backgroundColor: AppColors.primaryLight,
                      );
                    },
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).padding.bottom + 10.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
