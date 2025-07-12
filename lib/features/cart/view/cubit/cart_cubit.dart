import 'package:cozy/core/constants/widgets/print_util.dart';
import 'package:cozy/features/cart/data/model/cart_model.dart';
import 'package:cozy/features/cart/view/cubit/cart_state.dart';
import 'package:cozy/features/home/data/model/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial()) {
    _cart = Cart()
        .addItem(sampleProductsNewArrivals[0], quantity: 2)
        .addItem(sampleProductsPopular[0], quantity: 1);
  }

  late Cart _cart;

  Cart get cart => _cart;

  void updateCartItemQuantity(String productId, int newQuantity) {
    _cart = _cart.updateItemQuantity(productId, newQuantity);
    emit(CartUpdated());
  }

  void removeFromCart(String productId) {
    PrintUtil.debug('Removing item with productId: $productId');
    PrintUtil.debug('Cart before removal: $_cart');
    _cart = _cart.removeItem(productId);
    PrintUtil.debug('Cart after removal: $_cart');
    emit(CartUpdated());
  }
}
