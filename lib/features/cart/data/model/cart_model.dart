import 'package:cozy/features/home/data/model/product_model.dart';

class CartItem {
  final String id;
  final ProductModel product;
  int quantity;
  final DateTime addedAt;
  String? selectedSize;
  String? selectedColor;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    DateTime? addedAt,
    this.selectedSize,
    this.selectedColor,
  }) : addedAt = addedAt ?? DateTime.now();

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    String? id,
    ProductModel? product,
    int? quantity,
    DateTime? addedAt,
    String? selectedSize,
    String? selectedColor,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
      'selectedSize': selectedSize,
      'selectedColor': selectedColor,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'],
      addedAt: DateTime.parse(json['addedAt']),
      selectedSize: json['selectedSize'],
      selectedColor: json['selectedColor'],
    );
  }
}

class Cart {
  final List<CartItem> items;
  final DateTime lastUpdated;

  Cart({
    List<CartItem>? items,
    DateTime? lastUpdated,
  })  : items = items ?? [],
        lastUpdated = lastUpdated ?? DateTime.now();

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);

  double get shipping => subtotal > 100 ? 0 : 25.0; // Free shipping over $100

  double get tax => subtotal * 0.08; // 8% tax

  double get total => subtotal + shipping + tax;

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;

  CartItem? findItem(String productId) {
    try {
      return items.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }

  Cart addItem(ProductModel product,
      {int quantity = 1, String? size, String? color}) {
    final existingItem = findItem(product.id);

    if (existingItem != null) {
      // Update existing item quantity
      final updatedItems = items.map((item) {
        if (item.product.id == product.id) {
          return item.copyWith(quantity: item.quantity + quantity);
        }
        return item;
      }).toList();

      return Cart(items: updatedItems);
    } else {
      // Add new item
      final newItem = CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        product: product,
        quantity: quantity,
        selectedSize: size,
        selectedColor: color,
      );

      return Cart(items: [...items, newItem]);
    }
  }

  Cart removeItem(String itemId) {
    final updatedItems = items.where((item) => item.id != itemId).toList();
    return Cart(items: updatedItems);
  }

  Cart updateItemQuantity(String itemId, int newQuantity) {
    if (newQuantity <= 0) {
      return removeItem(itemId);
    }

    final updatedItems = items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();

    return Cart(items: updatedItems);
  }

  Cart clear() {
    return Cart(items: []);
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}
