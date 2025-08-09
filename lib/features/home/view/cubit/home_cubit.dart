import 'package:bloc/bloc.dart';

import '../../../../core/services/service_locator.dart';
import '../../../product/data/model/product_details_model.dart';
import '../../data/model/category_model.dart';
import '../../data/model/product_model.dart';
import '../../data/repo/home_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo = sl<HomeRepo>();
  HomeCubit() : super(HomeInitial());

  List<CategoryModel> categories = [];
  List<ProductModel> products = [];
  List<ProductDetailsModel> productDetails = [];
  int selectedCategoryIndex = 0;
  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMore = true;

  void initialize() {
    fetchCategories();
    fetchProducts();
  }

  Future<void> fetchCategories() async {
    emit(HomeLoading());
    final result = await homeRepo.fetchCategories();
    result.fold(
      (error) => emit(HomeError(error)),
      (data) {
        categories = data;
        emit(HomeLoaded(categories: data));
      },
    );
  }

  Future<void> fetchProducts({bool isRefresh = false}) async {
    if (isLoadingMore) return;

    if (isRefresh) {
      resetPagination();
      emit(HomeProductsLoading());
    } else if (!hasMore) {
      return;
    }

    isLoadingMore = true;
    final categoryId =
        selectedCategoryIndex > 0 ? categories[selectedCategoryIndex].id : null;
    final name = selectedCategoryIndex == 0
        ? null
        : categories[selectedCategoryIndex].name;

    final result = await homeRepo.getProducts(
      categoryId: categoryId,
      page: currentPage,
      name: name,
    );
    result.fold(
      (error) => emit(HomeProductsError(error)),
      (data) {
        products.addAll(data['products'] as List<ProductModel>);
        updatePagination(data['meta'] as Map<String, dynamic>);
        emit(HomeProductsLoaded());
      },
    );
    isLoadingMore = false;
  }

  void selectCategory(int index) {
    selectedCategoryIndex = index;
    fetchProducts(isRefresh: true);
    emit(HomeCategorySelected(index: index));
  }

  void resetPagination() {
    currentPage = 1;
    products.clear();
    hasMore = true;
  }

  void updatePagination(Map<String, dynamic> meta) {
    hasMore = currentPage < (meta['last_page'] as int);
    if (hasMore) currentPage++;
  }

  Future<void> fetchProductDetails(int productId) async {
    emit(ProductDetailsLoading());
    final result = await homeRepo.getProductDetails(productId);
    result.fold(
      (error) => emit(ProductDetailsError(error)),
      (product) {
        // productDetails.add(product);
        productDetails = [product];
        emit(ProductDetailsLoaded());
      },
    );
  }
}
