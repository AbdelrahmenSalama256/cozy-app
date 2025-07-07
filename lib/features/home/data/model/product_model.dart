class ProductModel {
  final String id;
  final String nameKey;
  final String descriptionKey;
  final String imagePath;
  final double price;
  final double? oldPrice;
  final String categoryKey;
  final String storeNameKey;
  final String currencySymbolKey;
  final double rating;
  final int reviewCount;
  final bool isFavorite;
  final bool isInStock;
  final List<String> imageGallery;
  final Map<String, String> specifications;
  final List<String> availableSizes;
  final List<String> availableColors;

  ProductModel({
    required this.id,
    required this.nameKey,
    required this.descriptionKey,
    required this.imagePath,
    required this.price,
    this.oldPrice,
    required this.categoryKey,
    required this.storeNameKey,
    required this.currencySymbolKey,
    required this.rating,
    required this.reviewCount,
    this.isFavorite = false,
    this.isInStock = true,
    this.imageGallery = const [],
    this.specifications = const {},
    this.availableSizes = const [],
    this.availableColors = const [],
  });

  ProductModel copyWith({
    String? id,
    String? nameKey,
    String? descriptionKey,
    String? imagePath,
    double? price,
    double? oldPrice,
    String? categoryKey,
    String? storeNameKey,
    String? currencySymbolKey,
    double? rating,
    int? reviewCount,
    bool? isFavorite,
    bool? isInStock,
    List<String>? imageGallery,
    Map<String, String>? specifications,
    List<String>? availableSizes,
    List<String>? availableColors,
  }) {
    return ProductModel(
      id: id ?? this.id,
      nameKey: nameKey ?? this.nameKey,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      imagePath: imagePath ?? this.imagePath,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      categoryKey: categoryKey ?? this.categoryKey,
      storeNameKey: storeNameKey ?? this.storeNameKey,
      currencySymbolKey: currencySymbolKey ?? this.currencySymbolKey,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isFavorite: isFavorite ?? this.isFavorite,
      isInStock: isInStock ?? this.isInStock,
      imageGallery: imageGallery ?? this.imageGallery,
      specifications: specifications ?? this.specifications,
      availableSizes: availableSizes ?? this.availableSizes,
      availableColors: availableColors ?? this.availableColors,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameKey': nameKey,
      'descriptionKey': descriptionKey,
      'imagePath': imagePath,
      'price': price,
      'oldPrice': oldPrice,
      'categoryKey': categoryKey,
      'storeNameKey': storeNameKey,
      'currencySymbolKey': currencySymbolKey,
      'rating': rating,
      'reviewCount': reviewCount,
      'isFavorite': isFavorite,
      'isInStock': isInStock,
      'imageGallery': imageGallery,
      'specifications': specifications,
      'availableSizes': availableSizes,
      'availableColors': availableColors,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      nameKey: json['nameKey'],
      descriptionKey: json['descriptionKey'],
      imagePath: json['imagePath'],
      price: json['price'].toDouble(),
      oldPrice: json['oldPrice']?.toDouble(),
      categoryKey: json['categoryKey'],
      storeNameKey: json['storeNameKey'],
      currencySymbolKey: json['currencySymbolKey'],
      rating: json['rating'].toDouble(),
      reviewCount: json['reviewCount'],
      isFavorite: json['isFavorite'] ?? false,
      isInStock: json['isInStock'] ?? true,
      imageGallery: List<String>.from(json['imageGallery'] ?? []),
      specifications: Map<String, String>.from(json['specifications'] ?? {}),
      availableSizes: List<String>.from(json['availableSizes'] ?? []),
      availableColors: List<String>.from(json['availableColors'] ?? []),
    );
  }
}

// Sample data with updated structure
final List<ProductModel> sampleProductsNewArrivals = [
  ProductModel(
    id: '1',
    nameKey: 'modern_chair',
    descriptionKey: 'comfortable_modern_chair_description',
    imagePath:
        'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=400&h=300&q=80',
    price: 299.99,
    oldPrice: 399.99,
    categoryKey: 'chair',
    storeNameKey: 'furniture_store',
    currencySymbolKey: 'currency_symbol',
    rating: 4.5,
    reviewCount: 128,
    availableSizes: ['Small', 'Medium', 'Large'],
    availableColors: ['Brown', 'Black', 'White'],
    imageGallery: [
      'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=400&h=300&q=80',
      'https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?auto=format&fit=crop&w=400&h=300&q=80',
    ],
    specifications: {
      'Material': 'Premium Leather',
      'Dimensions': '80x70x90 cm',
      'Weight': '15 kg',
      'Color': 'Brown',
    },
  ),
  ProductModel(
    id: '2',
    nameKey: 'comfortable_sofa',
    descriptionKey: 'luxury_sofa_description',
    imagePath:
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=400&h=300&q=80',
    price: 899.99,
    categoryKey: 'sofa',
    storeNameKey: 'furniture_store',
    currencySymbolKey: 'currency_symbol',
    rating: 4.8,
    reviewCount: 89,
    availableSizes: ['2-Seater', '3-Seater', 'L-Shape'],
    availableColors: ['Grey', 'Blue', 'Beige'],
    imageGallery: [
      'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=400&h=300&q=80',
      'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=400&h=300&q=80',
    ],
    specifications: {
      'Material': 'Fabric',
      'Dimensions': '200x90x80 cm',
      'Weight': '45 kg',
      'Color': 'Grey',
    },
  ),
];

final List<ProductModel> sampleProductsPopular = [
  ProductModel(
    id: '3',
    nameKey: 'wooden_table',
    descriptionKey: 'solid_wood_table_description',
    imagePath:
        'https://images.unsplash.com/photo-1549497538-303791108f95?auto=format&fit=crop&w=400&h=300&q=80',
    price: 599.99,
    categoryKey: 'table',
    storeNameKey: 'furniture_store',
    currencySymbolKey: 'currency_symbol',
    rating: 4.6,
    reviewCount: 156,
    availableSizes: ['Small', 'Medium', 'Large'],
    availableColors: ['Natural Wood', 'Dark Brown', 'White'],
  ),
  ProductModel(
    id: '4',
    nameKey: 'luxury_bed',
    descriptionKey: 'king_size_bed_description',
    imagePath:
        'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=400&h=300&q=80',
    price: 1299.99,
    categoryKey: 'bed',
    storeNameKey: 'furniture_store',
    currencySymbolKey: 'currency_symbol',
    rating: 4.9,
    reviewCount: 203,
    availableSizes: ['Queen', 'King', 'Super King'],
    availableColors: ['White', 'Grey', 'Black'],
  ),
];
