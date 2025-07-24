import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  
  AuthCubit() : super(AuthInitial()) {
    usernameController = TextEditingController();
    createAccountEmailController = TextEditingController();
    createAccountPasswordController = TextEditingController();
    loginEmailController = TextEditingController();
    loginPasswordController = TextEditingController();
    forgotPasswordEmailController = TextEditingController();
    otpController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmNewPasswordController = TextEditingController();
  }

  late TextEditingController usernameController;
  late TextEditingController createAccountEmailController;
  late TextEditingController createAccountPasswordController;
  late TextEditingController loginEmailController;
  late TextEditingController loginPasswordController;
  late TextEditingController forgotPasswordEmailController;
  late TextEditingController otpController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmNewPasswordController;
  late GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isCreateAccountPasswordObscure = true;
  bool isLoginPasswordObscure = true;
  bool isNewPasswordObscure = true;
  bool isConfirmNewPasswordObscure = true;

  void togglePasswordVisibility(String fieldType) {
    if (fieldType == 'createAccount') {
      isCreateAccountPasswordObscure = !isCreateAccountPasswordObscure;
    } else if (fieldType == 'login') {
      isLoginPasswordObscure = !isLoginPasswordObscure;
    } else if (fieldType == 'new') {
      isNewPasswordObscure = !isNewPasswordObscure;
    } else if (fieldType == 'confirm') {
      isConfirmNewPasswordObscure = !isConfirmNewPasswordObscure;
    }
    emit(AuthPasswordVisibilityChanged(
        isObscure: _getObscurityStatus(fieldType), fieldType: fieldType));
  }

  bool _getObscurityStatus(String fieldType) {
    if (fieldType == 'createAccount') return isCreateAccountPasswordObscure;
    if (fieldType == 'login') return isLoginPasswordObscure;
    if (fieldType == 'new') return isNewPasswordObscure;
    if (fieldType == 'confirm') return isConfirmNewPasswordObscure;
    return true;
  }

  Future<void> attemptAccountCreation(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    emit(AuthLoading());
    await Future.delayed(Duration(seconds: 1));
    emit(AuthCreateAccountSuccess(
        message: "auth_create_account_success",
        emailForVerification: createAccountEmailController.text));
  }

  Future<void> verifyOtpForAccountCreation() async {
    emit(AuthOtpVerificationLoading());
    await Future.delayed(Duration(seconds: 1));
    final otp = otpController.text;
    if (otp.length != 4) {
      emit(AuthFailure(error: "invalid_otp"));
      return;
    }
    if (otp == "0000") {
      emit(AuthFailure(error: "invalid_otp"));
      return;
    }
    otpController.clear();
    emit(AuthOtpVerificationSuccess(message: "auth_otp_verified_success"));
  }

  Future<void> attemptLogin(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    emit(AuthLoading());
    await Future.delayed(Duration(seconds: 1));
    emit(AuthLoginSuccess(message: "auth_login_success"));
  }

  Future<void> sendForgotPasswordCode(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    emit(AuthLoading());
    await Future.delayed(Duration(seconds: 1));
    emit(AuthForgotPasswordOtpSent(
        message: "auth_otp_sent",
        emailOrPhone: forgotPasswordEmailController.text));
  }

  Future<void> verifyResetOtpAndShowCreateNewPassword() async {
    emit(AuthOtpVerificationLoading());
    await Future.delayed(Duration(seconds: 1));
    final otp = otpController.text;
    if (otp.length != 4) {
      emit(AuthFailure(error: "invalid_otp"));
      return;
    }
    if (otp == "0000") {
      emit(AuthFailure(error: "invalid_otp"));
      return;
    }
    otpController.clear();
    emit(AuthOtpVerificationSuccess(message: "auth_otp_verified_reset"));
  }

  Future<void> attemptResetPassword(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    emit(AuthLoading());
    await Future.delayed(Duration(seconds: 1));
    newPasswordController.clear();
    confirmNewPasswordController.clear();
    emit(AuthResetPasswordSuccess(message: "auth_password_reset_success"));
  }

  void disposeAllControllers() {
    usernameController.dispose();
    createAccountEmailController.dispose();
    createAccountPasswordController.dispose();
    loginEmailController.dispose();
    loginPasswordController.dispose();
    forgotPasswordEmailController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
  }

  @override
  Future<void> close() {
    disposeAllControllers();
    return super.close();
  }
}
