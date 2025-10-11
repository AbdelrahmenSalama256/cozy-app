import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/core/database/api/dio_consumer.dart';
import 'package:cozy/core/network/local_network.dart';
import 'package:cozy/features/cart/data/repo/cart_repo.dart';
import 'package:cozy/features/checkout/data/repo/checkout_repo.dart';
import 'package:cozy/features/customer_services/data/repo/customer_service_repo.dart';
import 'package:cozy/features/home/data/repo/home_repo.dart';
import 'package:cozy/features/profile/data/repo/orders_repo.dart';
import 'package:cozy/features/profile/data/repo/profile_repo.dart';
import 'package:cozy/features/wishlist/data/repo/wishlist_repo.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/repo/login_repo.dart';
import '../../features/auth/data/repo/register_repo.dart';
import '../../features/notifications/data/repo/notifications_repo.dart';
import '../../features/profile/data/repo/address_repo.dart';
import '../data/repo/settings_repo.dart';
import '../../features/profile/data/repo/about_repo.dart';

final sl = GetIt.instance;
void initServiceLocator() {
//!external
  sl.registerLazySingleton(() => CacheHelper());
  sl.registerLazySingleton(() => GlobalCubit());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => DioConsumer(sl<Dio>()));
  sl.registerLazySingleton(() => RegisterRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => LoginRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => HomeRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => CartRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => WishlistRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => ProfileRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => AddressRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => CheckoutRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => OrderRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => NotificationsRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => CustomerServiceRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => SettingsRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => AboutRepo(sl<DioConsumer>()));


  //! Repositorys
}
