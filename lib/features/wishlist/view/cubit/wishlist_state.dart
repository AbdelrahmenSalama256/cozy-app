class WishlistState {}

final class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {}

class WishlistError extends WishlistState {
  final String error;
  WishlistError(this.error);
}

class WishlistItemRemovedLoading extends WishlistState {}

class WishlistItemRemovedSuccess extends WishlistState {
  final String message;
  WishlistItemRemovedSuccess(this.message);
}

class WishlistItemRemovedError extends WishlistState {
  final String error;
  WishlistItemRemovedError(this.error);
}
