import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:outcrop/data/data.dart';
import 'package:outcrop/models/product_card_model.dart';
import 'package:outcrop/pages/category.dart';
import 'package:outcrop/pages/favourites.dart';
import 'package:outcrop/pages/home.dart';
import 'package:outcrop/pages/settings.dart';
import 'package:outcrop/services/product_services.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  final Set<String> _favorites = {};
  int _currentIndex = 0;

  Widget _buildProductsView({
    required Widget Function(List<ProductCardModel>) builder,
  }) {
    return FutureBuilder<List<ProductCardModel>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No products available"));
        }
        return builder(snapshot.data!);
      },
    );
  }

  final List<PreferredSizeWidget> _appbars = const [
    HomeAppBar(),
    FavouritesAppBar(),
    SettingsAppBar(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbars[_currentIndex],
      body: _body(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFA8FB71),
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorite'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _body() {
    switch (_currentIndex) {
      case 0:
        return _buildProductsView(
          builder: (products) => HomeBody(
            key: ValueKey(_favorites.length),
            categories: categoriesList,
            products: products,
            favorites: _favorites,
            onToggleFavorite: _toggleFavorite,
            onCategoryTap: (category) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryPage(
                    category: category,
                    allProducts: products,
                    favorites: _favorites,
                    onToggleFavorite: _toggleFavorite,
                  ),
                ),
              );
            },
          ),
        );

      case 1:
        return _buildProductsView(
          builder: (products) => FavouritesBody(
            key: ValueKey(_favorites.length),
            products: products,
            favorites: _favorites,
            onToggleFavorite: _toggleFavorite,
          ),
        );

      default:
        return SettingsBody(
          selectedDate: selectedDate,
          onDateChanged: _onDateChanged,
        );
    }
  }

  String selectedDate = "2026-01-01";
  late Future<List<ProductCardModel>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductService.fetchProductsByDate(selectedDate);
    _loadUserFavorites();
  }

  /// Load favorites + selectedDate from Firestore
  Future<void> _loadUserFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _loadProducts();
      return;
    }

    final doc = await FirebaseFirestore.instance
        .collection('users_fav')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      _favorites.addAll(List<String>.from(data['favorites'] ?? []));
      selectedDate = data['selectedDate'] ?? selectedDate;
    }

    _loadProducts();
    setState(() {});
  }

  void _loadProducts() {
    _productsFuture = ProductService.fetchProductsByDate(selectedDate);
  }

  Future<void> _toggleFavorite(ProductCardModel product) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      _favorites.contains(product.name)
          ? _favorites.remove(product.name)
          : _favorites.add(product.name);
    });

    await FirebaseFirestore.instance.collection('users_fav').doc(user.uid).set({
      'favorites': _favorites.toList(),
      'selectedDate': selectedDate,
    }, SetOptions(merge: true));
  }

  void _onDateChanged(String newDate) {
    setState(() {
      selectedDate = newDate;
      _productsFuture = ProductService.fetchProductsByDate(selectedDate);
      _currentIndex = 0;
    });
  }
}
