class CartItem {
  final int? id;
  final ProductModel? product;
  final int? quantity;
  final DateTime? addedAt;
  final int? variationId;
  final String? variationName;

  CartItem({
    this.id,
    this.product,
    this.quantity,
    this.addedAt,
    this.variationId,
    this.variationName,
  });

  double? get totalPrice => (product?.price ?? 0.0) * (quantity ?? 0);

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final variation = json['variation'] as Map<String, dynamic>? ?? {};
    final productJson = variation['product'] as Map<String, dynamic>? ?? {};
    return CartItem(
      id: json['id'] as int?,
      product: ProductModel.fromJson({
        ...productJson,
        'sell_price_inc_tax': variation['sell_price_inc_tax'] ?? '0',
        'image_url': productJson['image_url'] ?? '',
      }),
      quantity: json['quantity'] as int?,
      addedAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
      variationId: json['variation_id'] as int?,
      variationName: variation['name'] as String?,
    );
  }
}

class Cart {
  final List<CartItem> items;
  final int cartCount;
  final double? subtotal;
  final double? shipping;
  final double? tax;
  final double? total;
  final double? cartTotal;
  final double? finalTotal;
  final int? totalItems;
  final DateTime? lastUpdated;

  Cart({
    required this.items,
    required this.cartCount,
    this.subtotal,
    this.shipping,
    this.tax,
    this.total,
    this.cartTotal,
    this.finalTotal,
    this.totalItems,
    this.lastUpdated,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      items: (json['data'] as List?)
              ?.where((e) => e != null)
              .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      cartCount: json['cart_count'] as int? ?? 0,
      subtotal: double.tryParse(json['subtotal']?.toString() ?? '') ?? 0.0,
      shipping: double.tryParse(json['shipping']?.toString() ?? '') ?? 0.0,
      tax: double.tryParse(json['tax']?.toString() ?? '') ?? 0.0,
      total: double.tryParse(json['final_total']?.toString() ?? '') ?? 0.0,
      cartTotal: double.tryParse(json['cart_total']?.toString() ?? '') ?? 0.0,
      finalTotal: double.tryParse(json['final_total']?.toString() ?? '') ?? 0.0,
      totalItems: json['total_items'] as int? ?? 0,
      lastUpdated: DateTime.tryParse(json['last_updated'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

class ProductModel {
  final int? id;
  final String? name;
  final String? imagePath;
  final double? price;
  final String? storeName;
  final double? rating;
  final Map<String, String>? specifications;

  ProductModel({
    this.id,
    this.name,
    this.imagePath,
    this.price,
    this.storeName,
    this.rating,
    this.specifications,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int?,
      name: json['name'] as String? ?? 'Unknown',
      imagePath: json['image_url'] as String? ?? '',
      price:
          double.tryParse(json['sell_price_inc_tax'] as String? ?? '0') ?? 0.0,
      storeName: json['business_id'] != null
          ? 'Store ${json['business_id']}'
          : 'Unknown',
      rating: 4.5,
      specifications: {
        'Material': 'Not specified',
        'Dimensions': 'Not specified',
        'Color': 'Not specified',
        'Weight Capacity': 'Not specified',
      },
    );
  }
}
