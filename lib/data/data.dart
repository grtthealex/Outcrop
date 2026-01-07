import 'package:outcrop/models/category_card_model.dart';
import 'package:outcrop/models/product_card_model.dart';

final List<CategoryCardModel> categoriesList = [
  CategoryCardModel(
    imagePath: 'assets/images/rice.jpg',
    name: 'IMPORTED COMMERCIAL RICE',
  ),
  CategoryCardModel(
    imagePath: 'assets/images/rice.jpg',
    name: 'LOCAL COMMERCIAL RICE',
  ),
  CategoryCardModel(imagePath: 'assets/images/corn.png', name: 'CORN PRODUCTS'),
  CategoryCardModel(imagePath: 'assets/images/legumes.jpg', name: 'LEGUMES'),
  CategoryCardModel(imagePath: 'assets/images/fish.png', name: 'FISH PRODUCTS'),
  CategoryCardModel(
    imagePath: 'assets/images/beef.webp',
    name: 'BEEF MEAT PRODUCTS',
  ),
  CategoryCardModel(
    imagePath: 'assets/images/pork.png',
    name: 'PORK MEAT PRODUCTS',
  ),
  CategoryCardModel(
    imagePath: 'assets/images/carabeef.webp',
    name: 'OTHER LIVESTOCK MEAT PRODUCTS',
  ),
  CategoryCardModel(
    imagePath: 'assets/images/poultry.png',
    name: 'POULTRY PRODUCTS',
  ),
  CategoryCardModel(
    imagePath: 'assets/images/vege.jpg',
    name: 'LOWLAND VEGETABLES',
  ),
  CategoryCardModel(
    imagePath: 'assets/images/vege.jpg',
    name: 'HIGHLAND VEGETABLES',
  ),
  CategoryCardModel(imagePath: 'assets/images/spices.jpeg', name: 'SPICES'),
  CategoryCardModel(imagePath: 'assets/images/fruits.png', name: 'FRUITS'),
  CategoryCardModel(
    imagePath: 'assets/images/others.jpg',
    name: 'OTHER BASIC COMMODITIES',
  ),
];

final List<ProductCardModel> products = [
  ProductCardModel(
    name: 'Basmati Rice',
    spec: '5% broken',
    price: 50.0,
    category: 'IMPORTED COMMERCIAL RICE',
  ),
  ProductCardModel(
    name: 'Glutinous Rice',
    spec: '10% broken',
    price: 45.0,
    category: 'IMPORTED COMMERCIAL RICE',
  ),
  ProductCardModel(
    name: 'Yellow Corn',
    spec: 'Medium',
    price: 32.0,
    category: 'LOCAL COMMERCIAL RICE',
  ),
  ProductCardModel(
    name: 'Salmon',
    spec: 'Fresh',
    price: 200.0,
    category: 'FISH PRODUCTS',
  ),
  ProductCardModel(
    name: 'Pork Belly',
    spec: 'Lean',
    price: 150.0,
    category: 'PORK MEAT PRODUCTS',
  ),
];
