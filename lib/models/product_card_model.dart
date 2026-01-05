class ProductCardModel {
  final String imagePath;
  final String name;
  final String? spec;
  final double price;
  ProductCardModel({
    required this.imagePath,
    required this.name,
    this.spec,
    required this.price,
  });
}
