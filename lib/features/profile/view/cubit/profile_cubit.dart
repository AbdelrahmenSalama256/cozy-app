import 'package:bloc/bloc.dart';
import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/features/profile/view/cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../../../../core/common/logs.dart';
import '../../data/models/contact_model.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GlobalCubit globalCubit;

  ProfileCubit(this.globalCubit) : super(ProfileInitial()) {
    _initControllers();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  XFile? profileImage;
  bool hasChanges = false;

  void _initControllers() {
    final user = globalCubit.contactResponse?.data.user ??
        UserDetails(
          id: 0,
          type: '',
          contactId: '',
          contactStatus: 'active',
        );

    // Use name if available, otherwise combine first and last name
    nameController.text = user.name ??
        (user.firstName != null && user.lastName != null
            ? '${user.firstName} ${user.lastName}'
            : '');
    emailController.text = user.email ?? '';
    mobileController.text = user.mobile ?? '';

    nameController.addListener(checkForChanges);
    emailController.addListener(checkForChanges);
    mobileController.addListener(checkForChanges);
  }

  void setProfileImage(XFile image) {
    final extension = path.extension(image.path).toLowerCase();
    if (['.jpeg', '.jpg', '.png', '.gif', '.svg'].contains(extension)) {
      profileImage = image;
      checkForChanges();
      emit(ProfileImageUpdated(profileImage: profileImage));
    } else {
      Print.info("Invalid image format - ${image.path}");
      emit(ProfileImageError(
          'Image must be of type jpeg, jpg, png, gif, or svg'));
    }
  }

  void clearProfileImage() {
    profileImage = null;
    checkForChanges();
    emit(ProfileImageCleared());
  }

  void checkForChanges() {
    final user = globalCubit.contactResponse?.data.user ??
        UserDetails(
          id: 0,
          type: '',
          contactId: '',
          contactStatus: 'active',
        );

    // Compare with current user data
    final currentName = user.name ??
        (user.firstName != null && user.lastName != null
            ? '${user.firstName} ${user.lastName}'
            : '');

    final newState = nameController.text != currentName ||
        emailController.text != (user.email ?? '') ||
        mobileController.text != (user.mobile ?? '') ||
        profileImage != null;

    if (newState != hasChanges) {
      hasChanges = newState;
      emit(ProfileDataUpdated(hasChanges: hasChanges));
    }
  }

  Future<void> saveChanges() async {
    if (!formKey.currentState!.validate()) return;

    // Split name into first and last if needed
    final nameParts = nameController.text.split(' ');
    if (nameParts.length > 1) {
    } else {}

    await globalCubit.updateProfile(
      name: nameController.text,
      email: emailController.text,
      mobile: mobileController.text,
      image: profileImage,
    );

    clearProfileImage();
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    return super.close();
  }
}
