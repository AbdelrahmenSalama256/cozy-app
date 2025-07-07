import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:cozy/core/cubit/global_cubit.dart';
import 'package:cozy/core/database/api/dio_consumer.dart';
import 'package:cozy/core/network/local_network.dart';

final sl = GetIt.instance;
void initServiceLocator() {
//!external
  sl.registerLazySingleton(() => CacheHelper());
  sl.registerLazySingleton(() => GlobalCubit());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => DioConsumer(sl<Dio>()));
  // sl.registerLazySingleton(() => DataConnectionChecker());
  // sl.registerLazySingleton(() => NetworkInfoImpl(sl<DataConnectionChecker>()));
  //! Repositorys
}
