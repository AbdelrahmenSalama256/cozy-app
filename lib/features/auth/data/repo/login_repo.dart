// features/auth/data/repo/login_repo.dart
import 'package:cozy/core/constants/widgets/errors/exceptions.dart';
import 'package:cozy/core/database/api/api_consumer.dart';
import 'package:cozy/features/auth/data/models/user_login_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/database/api/end_points.dart';

class LoginRepo {
  final ApiConsumer api;

  LoginRepo(this.api);

  Future<Either<String, UserLoginModel>> loginUser({
    String? phone,
    String? password,
  }) async {
    try {
      final response = await api.post(
        EndPoints.login,
        data: {
          'mobile': phone,
          'password': password,
        },
        isFormData: false,
      );

      final userData = UserLoginModel.fromJson(response.data['data']);
      return Right(userData);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }
}
