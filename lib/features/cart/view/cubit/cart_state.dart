class CartState {}

final class CartInitial extends CartState {}

class CartUpdated extends CartState {}

class GetCartLoading extends CartState {}

class GetCartLoaded extends CartState {}

class GetCartError extends CartState {
  final String error;
  GetCartError(this.error);
}

class CartItemRemovedLoading extends CartState {}

class CartItemRemovedSuccess extends CartState {
  final String message;
  CartItemRemovedSuccess(this.message);
}

class CartItemRemovedError extends CartState {
  final String error;
  CartItemRemovedError(this.error);
}

class CartItemQuantityUpdated extends CartState {
  final String message;
  CartItemQuantityUpdated(this.message);
}

class CartItemQuantityUpdateError extends CartState {
  final String error;
  CartItemQuantityUpdateError(this.error);
}

class CartLoading extends CartState {}

class ClearCartLoading extends CartState {}

class ClearCartSuccess extends CartState {
  final String message;
  ClearCartSuccess(this.message);
}

class ClearCartError extends CartState {
  final String error;
  ClearCartError(this.error);
}
