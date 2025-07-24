// features/auth/view/cubit/register_state.dart
import 'package:image_picker/image_picker.dart';

class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String message;
  final String emailForVerification;

  RegisterSuccess({required this.message, required this.emailForVerification});
}

class RegisterError extends RegisterState {
  final String message;
  RegisterError({required this.message});
}

class RegisterPasswordVisibilityChanged extends RegisterState {
  final bool isObscure;
  RegisterPasswordVisibilityChanged({required this.isObscure});
}

class RegisterDataUpdated extends RegisterState {
  final XFile? profileImage;
  RegisterDataUpdated({this.profileImage});
}
