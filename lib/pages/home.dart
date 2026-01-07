import 'package:flutter/material.dart';
import 'package:outcrop/models/product_card_model.dart';
import 'package:outcrop/widgets/product_card_widget.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(56);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF41E9C7),
      title: SizedBox(
        width: 250,
        height: 40,
        child: TextField(
          textAlignVertical: TextAlignVertical.bottom,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
            hint: Text('Search'),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.search),
                  SizedBox(width: 8),
                  Text('|'),
                ],
              ),
            ),
          ),
        ),
      ),
      centerTitle: true,
    );
  }
}

class HomeBody extends StatelessWidget {
  final List<ProductCardModel> products;
  final Set<String> favorites;
  final Function(ProductCardModel) onToggleFavorite;

  const HomeBody({
    super.key,
    required this.products,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    // return SingleChildScrollView(
    //   padding: const EdgeInsets.all(30),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.stretch,
    //     children: products.map((product) {
    //       return Padding(
    //         padding: const EdgeInsets.only(bottom: 16),
    //         child: ProductCardWidget(
    //           product: product,
    //           isFavorite: favorites.contains(product.name),
    //           onFavoriteToggle: () => onToggleFavorite(product),
    //         ),
    //       );
    //     }).toList(),
    //   ),
    // );
    return ListView.builder(
      padding: const EdgeInsets.all(30),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Center(
            child: ProductCardWidget(
              product: product,
              isFavorite: favorites.contains(product.name),
              onFavoriteToggle: () => onToggleFavorite(product),
            ),
          ),
        );
      },
    );
  }
}
