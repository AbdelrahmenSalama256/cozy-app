import 'dart:async';
import 'dart:convert';

import 'package:cozy/core/constants/app_constant.dart';
import 'package:cozy/core/constants/widgets/print_util.dart';
import 'package:cozy/core/data/repo/settings_repo.dart';
import 'package:cozy/core/network/local_network.dart';
import 'package:cozy/core/services/service_locator.dart';
import 'package:cozy/features/cart/data/repo/cart_repo.dart';
import 'package:cozy/features/wishlist/data/repo/wishlist_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../features/cart/data/model/cart_model.dart';
import '../../features/profile/data/models/contact_model.dart';
import '../../features/profile/data/repo/profile_repo.dart';
import '../../features/wishlist/data/model/wishlist_model.dart';
import '../notification/notification_handler.dart';
import 'global_state.dart';

//! GlobalCubit
class GlobalCubit extends Cubit<GlobalState> {
  GlobalCubit() : super(GlobalInitial());

  void init() {
    PrintUtil.warning(
        "User type is ${sl<CacheHelper>().getDataString(key: AppConstants.userType)}");
    PrintUtil.success(
        "${sl<CacheHelper>().getDataString(key: AppConstants.token)}");
    PrintUtil.success(NotificationHandler.getToken());

    _initCurrency();
    _fetchAndApplySettings();
    getProfile();
  }

  int currentNavIndex = 0;
  ScrollController controller = ScrollController();
  Stream<ContactResponse?> get profileStream => _profileController.stream;
  final _profileController = StreamController<ContactResponse?>.broadcast();

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

  String currencyCode = "EGP";
  String currencySymbol = "LE";

  void _initCurrency() {
    final cache = sl<CacheHelper>();
    final cachedCode = cache.getDataString(key: AppConstants.currencyCode);
    final cachedSymbol = cache.getDataString(key: AppConstants.currencySymbol);
    if (cachedCode != null && cachedCode.isNotEmpty) {
      currencyCode = cachedCode;
    }
    if (cachedSymbol != null && cachedSymbol.isNotEmpty) {
      currencySymbol = cachedSymbol;
    } else {
      currencySymbol = _defaultSymbolForCodeAscii(currencyCode);
    }
  }

  void changeCurrency({required String code, String? symbol}) {
    currencyCode = code;
    currencySymbol = symbol ?? _defaultSymbolForCodeAscii(code);
    final cache = sl<CacheHelper>();
    cache.setData(AppConstants.currencyCode, currencyCode);
    cache.setData(AppConstants.currencySymbol, currencySymbol);
    emit(CurrencyChangedState(currencyCode, currencySymbol));
  }

  String _defaultSymbolForCodeAscii(String code) {
    switch (code.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EGP':
        return 'EGP';
      case 'SAR':
        return 'SAR';
      case 'AED':
        return 'AED';
      case 'EUR':
        return 'EUR';
      case 'GBP':
        return 'GBP';
      default:
        return '\$';
    }
  }

  bool get isAuthenticated {
    final token = sl<CacheHelper>().getDataString(key: AppConstants.token);
    return token != null && token.isNotEmpty;
  }

  Future<void> _fetchAndApplySettings() async {
    try {
      final result = await sl<SettingsRepo>().fetchSettings();
      result.fold((error) {
        // ignore errors silently; keep defaults
      }, (settings) {
        if ((settings.currency ?? '').isNotEmpty) {
          // Update currency symbol from settings; assume SAR unless overridden later
          changeCurrency(
              code: currencyCode.isNotEmpty ? currencyCode : 'SAR',
              symbol: settings.currency);
        }
        // Optionally, store name/logo for later use
        // Could cache via CacheHelper if needed
      });
    } catch (_) {
      // swallow
    }
  }

  Future<void> getProfile({bool forceRefresh = false}) async {
    emit(ProfileLoading());

    final cacheHelper = sl<CacheHelper>();
    final token = cacheHelper.getDataString(key: AppConstants.token);

    if (token == null) {
      PrintUtil.error("No token found, user is not logged in.");
      emit(ProfileError(message: "No token found, please log in."));
      _profileController.add(null);
      return;
    }

    if (!forceRefresh &&
        cacheHelper.getDataString(key: AppConstants.userProfile) != null) {
      try {
        contactResponse = ContactResponse.fromJson(jsonDecode(
            cacheHelper.getDataString(key: AppConstants.userProfile)!));
        PrintUtil.success(
            "Loaded user profile from cache: ${contactResponse!.data.user.name}");
        emit(ProfileLoaded());
        _profileController.add(contactResponse); // إضافة البيانات للستريم

        _fetchAndUpdateProfile();
        return;
      } catch (e) {
        PrintUtil.error("Error parsing cached profile: $e");
      }
    }

    await _fetchAndUpdateProfile();
  }

  Future<void> _fetchAndUpdateProfile() async {
    final response = await sl<ProfileRepo>().getProfile();
    response.fold(
      (failure) {
        PrintUtil.error("Failed to get profile: $failure");
        emit(ProfileError(message: failure));
        _profileController.add(null);
      },
      (newContactResponse) {
        contactResponse = newContactResponse;
        sl<CacheHelper>().setData(
            AppConstants.userProfile, jsonEncode(contactResponse?.toJson()));
        PrintUtil.success(
            "User profile fetched successfully: ${contactResponse?.data.user.name}");
        emit(ProfileLoaded());
        _profileController.add(contactResponse); // إضافة البيانات للستريم
      },
    );
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? mobile,
    XFile? image,
  }) async {
    emit(ProfileUpdating());
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
        getProfile(forceRefresh: true); // إعادة تحميل البيانات من السيرفر
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

  List<Cart> cartItems = [];

  Future<void> addToCart(
      {required String productId,
      required int quantity,
      required int variation}) async {
    emit(CartLoading());
    final result = await sl<CartRepo>().addToCart(
        productId: productId, quantity: quantity, variationId: variation);
    result.fold(
      (error) => emit(CartError(error)),
      (item) {
        emit(CartLoaded());
      },
    );
  }

  Future<void> addtowishlist({required String productId}) async {
    emit(WishlistLoading());
    final result = await sl<WishlistRepo>().addToWishlist(productId: productId);
    result.fold(
      (error) => emit(WishlistError(error)),
      (item) {
        emit(WishlistSuccess(item));
        // notify listeners that a product was added to wishlist so UI can update
        emit(WishlistStatusChanged(productId: productId, isFavourite: true));
      },
    );
  }

  Future<void> removeFromWishlist(int id, {String? productId}) async {
    emit(RemoveWishlistLoading());
    final result = await sl<WishlistRepo>().removeFromWishlist(id);
    result.fold(
      (error) => emit(WishlistItemRemovedError(error)),
      (message) {
        emit(WishlistItemRemovedSuccess(message));
        // notify UI to update product favourite state if productId was provided
        if (productId != null) {
          emit(WishlistStatusChanged(productId: productId, isFavourite: false));
        }
      },
    );
  }

  Future<void> removeProductFromWishlistByProductId(String productId) async {
    try {
      final wishlistResult = await sl<WishlistRepo>().getWishlist();
      wishlistResult.fold((error) {
        emit(WishlistItemRemovedError(error));
      }, (wishlist) async {
        WishlistItem? found;
        for (var item in wishlist.items) {
          if (item.productId.toString() == productId) {
            found = item;
            break;
          }
        }
        if (found != null) {
          await removeFromWishlist(found.id, productId: productId);
        } else {
          emit(WishlistItemRemovedError('wishlist_item_not_found'));
        }
      });
    } catch (e) {
      emit(WishlistItemRemovedError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _profileController.close();
    return super.close();
  }
}
