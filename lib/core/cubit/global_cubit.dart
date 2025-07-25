// core/cubit/global_state.dart
import 'package:cozy/core/constants/app_constant.dart';
import 'package:cozy/core/constants/widgets/print_util.dart';
import 'package:cozy/core/network/local_network.dart';
import 'package:cozy/core/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'global_state.dart';

class GlobalCubit extends Cubit<GlobalState> {
  GlobalCubit() : super(GlobalInitial()) {
    init();
  }

  void init() {
    PrintUtil.warning(
        "User type is ${sl<CacheHelper>().getDataString(key: AppConstants.userType)}");
    PrintUtil.debug(
        "User token is ${sl<CacheHelper>().getDataString(key: AppConstants.token)}");
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

    await Future.delayed(
        const Duration(milliseconds: 300)); // Animation duration

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
}
