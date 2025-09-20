import 'package:bloc/bloc.dart';

import '../../../../core/services/service_locator.dart';
import '../../../product/data/model/product_details_model.dart';
import '../../data/model/category_model.dart';
import '../../data/model/offer_product_model.dart';
import '../../data/model/offers_model.dart';
import '../../data/model/product_model.dart';
import '../../data/repo/home_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo = sl<HomeRepo>();
  HomeCubit() : super(HomeInitial());

  List<CategoryModel> categories = [];
  List<ProductModel> products = [];
  List<OfferModel> offers = [];
  List<OfferProductModel> offerProducts = []; // Add this

  List<ProductDetailsModel> productDetails = [];
  int selectedCategoryIndex = 0;
  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMore = true;
  String selectedVariationId = '';
  int quantity = 1;

  void initialize() {
    fetchCategories();
    fetchOffers();

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
    // Reset state
    selectedVariationId = '';
    quantity = 1;

    final result = await homeRepo.getProductDetails(productId);
    result.fold(
      (error) => emit(ProductDetailsError(error)),
      (product) {
        productDetails = [product];
        // Set default variation if exists
        if (product.variations?.isNotEmpty ?? false) {
          selectedVariationId = product.variations!.first.id?.toString() ?? '';
        }
        emit(ProductDetailsLoaded());
      },
    );
  }

  void selectVariation(String variationId) {
    selectedVariationId = variationId;
    emit(ProductVariationSelected());
  }

  void updateQuantity(int newQuantity) {
    quantity = newQuantity;
    emit(ProductQuantityUpdated());
  }

  Future<void> fetchOffers() async {
    emit(HomeOffersLoading());
    final result = await homeRepo.fetchOffers();
    result.fold(
      (error) => emit(HomeOffersError(error)),
      (data) {
        offers = data;
        emit(HomeOffersLoaded(data));
      },
    );
  }

  Future<void> fetchOfferProducts(int offerId) async {
    emit(HomeOfferProductsLoading());
    final result = await homeRepo.fetchOfferProducts(offerId);
    result.fold(
      (error) => emit(HomeOfferProductsError(error)),
      (data) {
        offerProducts = data;
        emit(HomeOfferProductsLoaded(data));
      },
    );
  }
}
