import 'package:bloc/bloc.dart';

import '../../../../core/services/service_locator.dart';
import '../../data/model/category_model.dart';
import '../../data/repo/home_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _homeRepo = sl<HomeRepo>();
  HomeCubit() : super(HomeInitial());
  void init() {
    fetchCategories();
  }

  List<CategoryModel> categories = [];
  int selectedCategoryIndex = 0;

  void fetchCategories() async {
    emit(HomeLoading());
    final result = await _homeRepo.fetchCategories();
    result.fold(
      (error) => emit(HomeError(error)),
      (data) {
        categories = data;
        emit(HomeLoaded(categories: data));
      },
    );
  }

  void selectCategory(int index) {
    selectedCategoryIndex = index;
    emit(HomeCategorySelected(index: index));
  }
}
