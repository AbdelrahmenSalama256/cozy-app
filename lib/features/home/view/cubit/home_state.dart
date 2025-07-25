import '../../data/model/category_model.dart';

class HomeState {}

final class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<CategoryModel> categories;
  HomeLoaded({required this.categories});
}

class HomeError extends HomeState {
  final String error;
  HomeError(this.error);
}

class HomeCategorySelected extends HomeState {
  final int index;
  HomeCategorySelected({required this.index});
}
