// features/auth/data/repo/login_repo.dart
import 'package:cozy/core/constants/widgets/errors/exceptions.dart';
import 'package:cozy/core/database/api/api_consumer.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/database/api/end_points.dart';
import '../../../profile/data/models/contact_model.dart';

class LoginRepo {
  final ApiConsumer api;

  LoginRepo(this.api);

  Future<Either<String, ContactResponse>> loginUser({
    String? username,
    String? password,
  }) async {
    try {
      final response = await api.post(
        EndPoints.login,
        data: {
          'username': username,
          'password': password,
        },
      );

      return Right(ContactResponse.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, String>> sendForgotPasswordCode(
      String emailOrPhone) async {
    try {
      final response = await api.post(
        EndPoints.forgotPassword,
        data: {'email': emailOrPhone},
        isFormData: true,
      );

      if (response.data is Map<String, dynamic> &&
          response.data['success'] == true) {
        final message =
            response.data['message']?.toString() ?? 'OTP sent successfully';
        return Right(message);
      } else {
        final errorMessage =
            response.data['message']?.toString() ?? 'Failed to send OTP';
        return Left(errorMessage);
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }
}
