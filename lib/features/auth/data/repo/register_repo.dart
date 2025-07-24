// features/auth/data/repo/register_repo.dart
import 'package:cozy/core/constants/widgets/errors/exceptions.dart';
import 'package:cozy/core/database/api/api_consumer.dart';
import 'package:cozy/core/notification/notification_handler.dart';
import 'package:cozy/features/auth/data/models/user_registration_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/common/common.dart';
import '../../../../core/database/api/end_points.dart';

class RegisterRepo {
  final ApiConsumer api;

  RegisterRepo(this.api);

  Future<Either<String, String>> registerUser(
      UserRegistrationModel user) async {
    try {
      final fcmToken = await NotificationHandler.getToken();

      final formData = {
        'username': user.username,
        'email': user.email,
        'password': user.password,
        'password_confirmation': user.passwordConfirmation,
        'name': user.name,
        'mobile': user.mobile,
        "image":
            user.image != null ? await uploadImageToAPI(user.image!) : null,
        'fcm_token': fcmToken,
      };

      final response = await api.post(
        EndPoints.register,
        data: formData,
        isFormData: true,
      );

      return Right(response.data['message'] ?? 'Registration successful');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }
}
