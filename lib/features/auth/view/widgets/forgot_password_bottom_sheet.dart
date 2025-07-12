// forgot_password_bottom_sheet.dart
import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/features/auth/view/cubit/auth_cubit.dart';
import 'package:cozy/features/auth/view/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/component/widgets/app_text_field.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/validator.dart';
import 'custom_bottom_sheet.dart';
import 'otp_bottom_sheet_for_reset.dart';

class ForgotPasswordBottomSheet extends StatelessWidget {
  const ForgotPasswordBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final authCubit = context.read<AuthCubit>();

        return BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthForgotPasswordOtpSent) {
              Navigator.of(context).pop();
              CustomBottomSheet.show(
                context: context,
                child: BlocProvider.value(
                  value: authCubit,
                  child: OtpBottomSheetForReset(
                    emailOrPhoneForOtp: state.emailOrPhone,
                  ),
                ),
              );
            }
          },
          child: Form(
            key: authCubit.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "auth_forgot_password_title".tr(context),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "auth_forgot_password_sheet_subtitle".tr(context),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textGrey,
                  ),
                ),
                SizedBox(height: 24.h),
                AppTextField(
                  controller: authCubit.forgotPasswordEmailController,
                  labelText: "auth_email_phone_label".tr(context),
                  hintText: "auth_email_phone_hint".tr(context),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppColors.textGrey.withOpacity(0.7),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      Validators.validateEmail(value, context),
                ),
                SizedBox(height: 24.h),
                AppButton(
                  text: "auth_send_code_button".tr(context),
                  isLoading: state is AuthLoading,
                  onPressed: () {
                    debugPrint(
                        'Form key state: ${authCubit.formKey.currentState}');

                    if (authCubit.formKey.currentState!.validate()) {
                      authCubit.sendForgotPasswordCode(authCubit.formKey);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
