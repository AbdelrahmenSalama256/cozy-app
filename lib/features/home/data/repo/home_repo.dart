import 'package:cozy/core/constants/widgets/errors/exceptions.dart';
import 'package:cozy/core/database/api/api_consumer.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/database/api/end_points.dart';
import '../model/category_model.dart';

class HomeRepo {
  final ApiConsumer api;

  HomeRepo(this.api);

  Future<Either<String, List<CategoryModel>>> fetchCategories() async {
    try {
      final response = await api.get(EndPoints.category);
      final data = response.data as Map<String, dynamic>?;
      final categories = (data?['data'] as List<dynamic>?)
          ?.map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return Right(categories ?? []);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }
}
