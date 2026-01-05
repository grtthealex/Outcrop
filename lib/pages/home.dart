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

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  // Dummy product list
  final List<ProductCardModel> products = [
    ProductCardModel(
      imagePath: 'assets/rice.png',
      name: 'Basmati Rice',
      spec: '5% broken',
      price: 50.0,
    ),
    ProductCardModel(
      imagePath: 'assets/rice.png',
      name: 'Glutinous Rice',
      price: 45.0,
    ),
    ProductCardModel(
      imagePath: 'assets/corn.png',
      name: 'Yellow Corn',
      spec: 'Medium',
      price: 32.0,
    ),
  ];

  // Set of favorite product names
  final Set<String> _favorites = {};

  // Toggle favorite
  void _toggleFavorite(ProductCardModel product) {
    setState(() {
      if (_favorites.contains(product.name)) {
        _favorites.remove(product.name);
      } else {
        _favorites.add(product.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: products.map((product) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Align(
              alignment: Alignment.center,
              child: ProductCardWidget(
                product: product,
                isFavorite: _favorites.contains(product.name),
                onFavoriteToggle: () => _toggleFavorite(product),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
