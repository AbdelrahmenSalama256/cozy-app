import 'dart:developer';

import 'package:cozy/core/constants/app_constant.dart';
import 'package:cozy/core/constants/widgets/print_util.dart';
import 'package:cozy/core/cubit/global_state.dart';
import 'package:cozy/core/network/local_network.dart';
import 'package:cozy/core/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalCubit extends Cubit<GlobalState> {
  GlobalCubit() : super(GlobalInitial());

  init() {
    PrintUtil.warning(
        "User type is ${sl<CacheHelper>().getDataString(key: AppConstants.userType)}");
  }

  int currentNavIndex = 0;
  ScrollController controller = ScrollController();

  void changeBottomNavIndex(int index) {
    if (currentNavIndex != index) {
      currentNavIndex = index;
      // controller.onAttach(index);
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
    log("Language changed to $language");

    emit(LanguageChangedState());
  }
}
