import 'package:cozy/core/component/widgets/app_button.dart';
import 'package:cozy/core/component/widgets/app_text_field.dart';
import 'package:cozy/core/constants/app_colors.dart';
import 'package:cozy/core/locale/app_loacl.dart';
import 'package:cozy/core/utils/validator.dart';
import 'package:cozy/features/auth/view/cubit/auth_cubit.dart';
import 'package:cozy/features/auth/view/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateNewPasswordBottomSheet extends StatelessWidget {
  const CreateNewPasswordBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final formKey = GlobalKey<FormState>();

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthResetPasswordSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text(state.message.tr(context)),
                backgroundColor: Colors.green));
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
                    "auth_create_new_password_title".tr(context),
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "auth_create_new_password_sheet_subtitle".tr(context),
                    style:
                        TextStyle(fontSize: 14.sp, color: AppColors.textGrey),
                  ),
                  SizedBox(height: 24.h),
                  AppTextField(
                    controller: authCubit.newPasswordController,
                    labelText: "auth_new_password_label".tr(context),
                    hintText: "auth_password_hint".tr(context),
                    prefixIcon: Icon(Icons.lock_outline,
                        color: AppColors.textGrey.withOpacity(0.7)),
                    obscureText: authCubit.isNewPasswordObscure,
                    suffixIcon: IconButton(
                      icon: Icon(
                        authCubit.isNewPasswordObscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textGrey,
                      ),
                      onPressed: () {
                        authCubit.togglePasswordVisibility('new');
                      },
                    ),
                    validator: (value) =>
                        Validators.validatePassword(value, context),
                  ),
                  SizedBox(height: 20.h),
                  AppTextField(
                    controller: authCubit.confirmNewPasswordController,
                    labelText: "auth_confirm_password_label".tr(context),
                    hintText: "auth_confirm_password_hint".tr(context),
                    prefixIcon: Icon(Icons.lock_outline,
                        color: AppColors.textGrey.withOpacity(0.7)),
                    obscureText: authCubit.isConfirmNewPasswordObscure,
                    suffixIcon: IconButton(
                      icon: Icon(
                        authCubit.isConfirmNewPasswordObscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textGrey,
                      ),
                      onPressed: () {
                        authCubit.togglePasswordVisibility('confirm');
                      },
                    ),
                    validator: (value) => Validators.validateConfirmPassword(
                        value, authCubit.newPasswordController.text, context),
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
                        text: "auth_change_password_button".tr(context),
                        onPressed: () {
                          authCubit.attemptResetPassword(formKey);
                        },
                        backgroundColor: AppColors.primaryLight,
                      );
                    },
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
