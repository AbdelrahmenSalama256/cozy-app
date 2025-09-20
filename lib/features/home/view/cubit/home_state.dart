import '../../data/model/category_model.dart';
import '../../data/model/offer_product_model.dart';
import '../../data/model/offers_model.dart';

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

class HomeProductsLoading extends HomeState {}

class HomeProductsError extends HomeState {
  final String error;
  HomeProductsError(this.error);
}

class HomeProductsLoaded extends HomeState {}

class ProductDetailsLoading extends HomeState {}

class ProductDetailsLoaded extends HomeState {}

class ProductDetailsError extends HomeState {
  final String message;

  ProductDetailsError(this.message);
}

class ProductVariationSelected extends HomeState {}

// ProductQuantityUpdated
class ProductQuantityUpdated extends HomeState {}

class HomeOffersLoading extends HomeState {}

class HomeOffersLoaded extends HomeState {
  final List<OfferModel> offers;

  HomeOffersLoaded(this.offers);
}

class HomeOffersError extends HomeState {
  final String message;

  HomeOffersError(this.message);
}

class HomeOfferProductsLoading extends HomeState {}

class HomeOfferProductsLoaded extends HomeState {
  final List<OfferProductModel> products;

  HomeOfferProductsLoaded(this.products);
}

class HomeOfferProductsError extends HomeState {
  final String message;

  HomeOfferProductsError(this.message);
}
