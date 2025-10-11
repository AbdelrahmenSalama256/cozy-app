import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/cart_model.dart';
import '../../data/repo/cart_repo.dart';
import 'cart_state.dart';

//! CartCubit
class CartCubit extends Cubit<CartState> {
  final CartRepo cartRepo;

  CartCubit(this.cartRepo) : super(CartInitial()) {
    fetchCart();
  }
  Cart? cart;
  Future<void> fetchCart() async {
    emit(GetCartLoading());
    final result = await cartRepo.getCartItems();
    result.fold(
      (error) => emit(GetCartError(error)),
      (cartItems) {
        cart = cartItems;
        emit(GetCartLoaded());
      },
    );
  }

  Future<void> removeFromCart(int id) async {
    emit(CartItemRemovedLoading());
    final result = await cartRepo.removeFromCart(id);
    result.fold(
      (error) => emit(CartItemRemovedError(error)),
      (cartItems) {

        emit(CartItemRemovedSuccess(cartItems));
      },
    );
  }

  Future<void> clearCart() async {
    emit(ClearCartLoading());
    final result = await cartRepo.clearCart();
    result.fold(
      (error) => emit(ClearCartError(error)),
      (cartItems) {

        emit(ClearCartSuccess(cartItems));
      },
    );
  }

  void updateCartItemQuantity(int itemId, int newQuantity) {

    emit(CartUpdated());
  }
}
