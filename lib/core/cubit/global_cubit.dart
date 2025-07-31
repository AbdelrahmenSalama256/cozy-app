import 'dart:convert';

import 'package:cozy/core/constants/app_constant.dart';
import 'package:cozy/core/constants/widgets/print_util.dart';
import 'package:cozy/core/network/local_network.dart';
import 'package:cozy/core/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../features/profile/data/models/contact_model.dart';
import '../../features/profile/data/repo/profile_repo.dart';
import 'global_state.dart';

class GlobalCubit extends Cubit<GlobalState> {
  GlobalCubit() : super(GlobalInitial());

  void init() {
    PrintUtil.warning(
        "User type is ${sl<CacheHelper>().getDataString(key: AppConstants.userType)}");
    PrintUtil.debug(
        "User token is ${sl<CacheHelper>().getDataString(key: AppConstants.token)}");
    getProfile();
  }

  int currentNavIndex = 0;
  ScrollController controller = ScrollController();

  void changeBottomNavIndex(int index) {
    if (currentNavIndex != index) {
      currentNavIndex = index;
      emit(BottomNavChangeState());
    }
  }

  String language = sl<CacheHelper>().getCachedLanguage();
  Future<void> changeLanguage() async {
    emit(LanguageChangingState());
    await Future.delayed(const Duration(milliseconds: 300));
    final newLanguage =
        sl<CacheHelper>().getCachedLanguage() == "en" ? "ar" : "en";
    await sl<CacheHelper>().cacheLanguage(newLanguage);
    language = newLanguage;
    PrintUtil.debug("Language changed to $language");
    emit(LanguageChangedState());
  }

  void updateToken(String token) {
    final cacheHelper = sl<CacheHelper>();
    cacheHelper.setData(AppConstants.token, token);
    PrintUtil.success("Global token updated: $token");
    emit(GlobalTokenUpdated());
  }

  ContactResponse? contactResponse;

  Future<void> getProfile({bool forceRefresh = false}) async {
    emit(ProfileLoading());

    final cacheHelper = sl<CacheHelper>();
    final token = cacheHelper.getDataString(key: AppConstants.token);

    if (token == null) {
      PrintUtil.error("No token found, user is not logged in.");
      emit(ProfileError(message: "No token found, please log in."));
      return;
    }

    // Load from cache if available and not forcing refresh
    if (!forceRefresh &&
        cacheHelper.getDataString(key: AppConstants.userProfile) != null) {
      try {
        contactResponse = ContactResponse.fromJson(jsonDecode(
            cacheHelper.getDataString(key: AppConstants.userProfile)!));
        PrintUtil.success(
            "Loaded user profile from cache: ${contactResponse!.data.user.name}");
        emit(ProfileLoaded());
        // Fetch fresh data in the background
        _fetchAndUpdateProfile();
        return;
      } catch (e) {
        PrintUtil.error("Error parsing cached profile: $e");
      }
    }

    // Fetch from server if no cache or forceRefresh is true
    await _fetchAndUpdateProfile();
  }

  Future<void> _fetchAndUpdateProfile() async {
    final response = await sl<ProfileRepo>().getProfile();
    response.fold(
      (failure) {
        PrintUtil.error("Failed to get profile: $failure");
        emit(ProfileError(message: failure));
      },
      (contactResponse) {
        contactResponse = contactResponse;
        sl<CacheHelper>().setData(
            AppConstants.userProfile, jsonEncode(contactResponse.toJson()));
        PrintUtil.success(
            "User profile fetched successfully: ${contactResponse.data.user.name}");
        emit(ProfileLoaded());
      },
    );
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? mobile,
    XFile? image,
  }) async {
    emit(ProfileLoading());
    final response = await sl<ProfileRepo>().updateProfile(
      name: name,
      email: email,
      mobile: mobile,
      image: image,
    );
    response.fold(
      (failure) {
        PrintUtil.error("Failed to update profile: $failure");
        emit(ProfileError(message: failure));
      },
      (message) {
        PrintUtil.success("Profile updated successfully: $message");
        getProfile();
        emit(ProfileUpdated());
      },
    );
  }

  Future<void> logout() async {
    emit(LogoutLoading());
    final response = await sl<ProfileRepo>().logout();
    response.fold(
      (failure) {
        PrintUtil.error("Failed to logout: $failure");
        emit(LogoutError(failure));
      },
      (message) {
        contactResponse = null;
        sl<CacheHelper>().removeData(key: AppConstants.userProfile);
        sl<CacheHelper>().removeData(key: AppConstants.token);
        currentNavIndex = 0;
        PrintUtil.success("Logged out successfully: $message");
        emit(LogoutSuccess(message));
      },
    );
  }
}
