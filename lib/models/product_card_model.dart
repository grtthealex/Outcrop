class ProductCardModel {
  final String name;
  final String? spec;
  final double price;
  final String category;

  ProductCardModel({
    required this.name,
    this.spec,
    required this.price,
    required this.category,
  });
}
