// features/auth/data/repo/login_repo.dart
import 'package:cozy/core/constants/widgets/errors/exceptions.dart';
import 'package:cozy/core/database/api/api_consumer.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/database/api/end_points.dart';
import '../models/user_login_model.dart';

class LoginRepo {
  final ApiConsumer api;

  LoginRepo(this.api);

  Future<Either<String, UserLoginModel>> loginUser({
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

      if (response.data is Map<String, dynamic> &&
          response.data['data'] != null) {
        final userData = UserLoginModel.fromJson(response.data);
        return Right(userData);
      } else {
        final errorMessage =
            response.data['message']?.toString() ?? 'Login failed';
        return Left(errorMessage);
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }
}
