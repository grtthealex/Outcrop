import 'package:flutter/material.dart';
import 'package:outcrop/models/product_card_model.dart';
import 'package:outcrop/widgets/product_card_widget.dart';

class FavouritesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FavouritesAppBar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(56);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF41E9C7),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: Colors.yellow),
          Text('Favourites'),
        ],
      ),
      centerTitle: true,
    );
  }
}

class FavouritesBody extends StatelessWidget {
  final List<ProductCardModel> products;
  final Set<String> favorites;
  final Function(ProductCardModel) onToggleFavorite;

  const FavouritesBody({
    super.key,
    required this.products,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final favProducts = products
        .where((product) => favorites.contains(product.name))
        .toList();

    if (favProducts.isEmpty) {
      return const Center(child: Text('No favorites yet'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(30),
      itemCount: favProducts.length,
      itemBuilder: (context, index) {
        final product = favProducts[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Center(
            child: ProductCardWidget(
              product: product,
              isFavorite: true,
              onFavoriteToggle: () => onToggleFavorite(product),
            ),
          ),
        );
      },
    );
  }
}
