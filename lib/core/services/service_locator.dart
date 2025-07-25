import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/core/database/api/dio_consumer.dart';
import 'package:cozy/core/network/local_network.dart';
import 'package:cozy/features/home/data/repo/home_repo.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/repo/login_repo.dart';
import '../../features/auth/data/repo/register_repo.dart';

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
  // sl.registerLazySingleton(() => DataConnectionChecker());
  // sl.registerLazySingleton(() => NetworkInfoImpl(sl<DataConnectionChecker>()));
  //! Repositorys
}
