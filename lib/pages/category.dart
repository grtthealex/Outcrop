import 'package:flutter/material.dart';
import '../models/product_card_model.dart';
import '../widgets/product_card_widget.dart';

class CategoryPage extends StatefulWidget {
  final String category;
  final String imagePath;
  final List<ProductCardModel> allProducts;
  final Set<String> favorites;
  final Function(ProductCardModel) onToggleFavorite;

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
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // 1. Filter by Category
    final categoryProducts =
        widget.allProducts.where((p) => p.category == widget.category).toList();

    // 2. Filter by Search Query
    final filteredProducts = categoryProducts.where((product) {
      return product.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: const Color(0xFF5ce1e6),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search in ${widget.category}...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = "";
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: filteredProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 10),
                  Text(
                    _searchQuery.isEmpty
                        ? "No products in this category"
                        : "No results for '$_searchQuery'",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ProductWidget(
                  product: product,
                  isFavorite: widget.favorites.contains(product.name),
                  onToggleFavorite: () {
                    // Triggers the root toggle
                    widget.onToggleFavorite(product);
                    // Forces local UI refresh for the heart icon
                    setState(() {});
                  },
                );
              },
            ),
    );
  }
}