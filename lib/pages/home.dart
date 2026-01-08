import 'package:flutter/material.dart';
import 'package:outcrop/models/category_card_model.dart';
import 'package:outcrop/models/product_card_model.dart';
import 'package:outcrop/widgets/category_card_widget.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(56);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Container(
        margin: EdgeInsets.all(10),
        child: Image.asset('assets/images/OutCrop_Logo.png'),
      ),
      backgroundColor: Color(0xFF41E9C7),
      title: Text('Commodities'),
      centerTitle: true,
    );
  }
}

class HomeBody extends StatelessWidget {
  final List<CategoryCardModel> categories;
  final List<ProductCardModel> products;
  final Set<String> favorites;
  final Function(ProductCardModel) onToggleFavorite;
  final Function(String) onCategoryTap; // add this

  const HomeBody({
    super.key,
    required this.categories,
    required this.products,
    required this.favorites,
    required this.onToggleFavorite,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Center(
              child: GestureDetector(
                onTap: () => onCategoryTap(category.name),
                child: CategoryCardWidget(category: category),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
