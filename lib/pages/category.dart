import 'package:flutter/material.dart';
import 'package:outcrop/models/product_card_model.dart';
import 'package:outcrop/widgets/product_card_widget.dart';

class CategoryPage extends StatefulWidget {
  final String category;
  final List<ProductCardModel> allProducts;
  final Set<String> favorites;
  final Function(ProductCardModel) onToggleFavorite;
  final String imagePath;

  const CategoryPage({
    super.key,
    required this.category,
    required this.allProducts,
    required this.favorites,
    required this.onToggleFavorite,
    required this.imagePath,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Filter products by category and search query
    final categoryProducts = widget.allProducts
        .where(
          (p) =>
              p.category == widget.category &&
              p.name.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5ce1e6),
        title: Text(widget.category),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                filled: true,
                fillColor: Color.fromARGB(255, 232, 249, 246),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                height: 120,
                width: double.infinity,
                child: ClipRect(
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            categoryProducts.isEmpty
                ? const Center(child: Text('No products found'))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: categoryProducts.length,
                    itemBuilder: (_, index) {
                      final product = categoryProducts[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ProductCardWidget(
                          product: product,
                          isFavorite: widget.favorites.contains(product.name),
                          onFavoriteToggle: () {
                            widget.onToggleFavorite(product);
                            setState(() {});
                          },
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
