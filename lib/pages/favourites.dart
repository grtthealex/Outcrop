// lib/pages/favourites.dart

import 'package:flutter/material.dart';
import '../models/product_card_model.dart';
import '../widgets/product_card_widget.dart';

class FavouritesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FavouritesAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('My Favorites'),
      centerTitle: true,
      backgroundColor: const Color(0xFF5ce1e6),
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
    // Only show products that are in the favorites set
    final favoriteProducts =
        products.where((p) => favorites.contains(p.name)).toList();

    if (favoriteProducts.isEmpty) {
      return const Center(
        child: Text("You haven't added any favorites yet."),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: favoriteProducts.length,
      itemBuilder: (context, index) {
        final product = favoriteProducts[index];
        // FIX: Pass the new required parameters to ProductWidget
        return ProductWidget(
          product: product,
          isFavorite: true, // Always true on this page
          onToggleFavorite: () => onToggleFavorite(product),
        );
      },
    );
  }
}