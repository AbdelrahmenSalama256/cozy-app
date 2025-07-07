class CategoryModel {
  final String id;
  final String nameKey;
  final String iconPath;
  final String imageUrl;
  final int productCount;

  CategoryModel({
    required this.id,
    required this.nameKey,
    required this.iconPath,
    required this.imageUrl,
    required this.productCount,
  });
}

final List<CategoryModel> sampleCategories = [
  CategoryModel(
    id: '1',
    nameKey: 'living_room',
    iconPath: 'assets/icons/sofa.png',
    imageUrl:
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=400&h=200&q=80',
    productCount: 45,
  ),
  CategoryModel(
    id: '2',
    nameKey: 'bedroom',
    iconPath: 'assets/icons/bed.png',
    imageUrl:
        'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=400&h=200&q=80',
    productCount: 32,
  ),
  CategoryModel(
    id: '3',
    nameKey: 'kitchen',
    iconPath: 'assets/icons/table.png',
    imageUrl:
        'https://images.unsplash.com/photo-1549497538-303791108f95?auto=format&fit=crop&w=400&h=200&q=80',
    productCount: 28,
  ),
  CategoryModel(
    id: '4',
    nameKey: 'office',
    iconPath: 'assets/icons/chair.png',
    imageUrl:
        'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=400&h=200&q=80',
    productCount: 19,
  ),
];
