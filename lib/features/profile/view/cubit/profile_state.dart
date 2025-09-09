import 'package:image_picker/image_picker.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {}

class ProfileImageUpdated extends ProfileState {
  final XFile? profileImage;

  const ProfileImageUpdated({this.profileImage});
}

class ProfileImageCleared extends ProfileState {}

class ProfileImageError extends ProfileState {
  final String message;

  const ProfileImageError(this.message);
}

class ProfileDataUpdated extends ProfileState {
  final bool hasChanges;
  ProfileDataUpdated({required this.hasChanges});
}

class ProfileUpdating extends ProfileState {}
