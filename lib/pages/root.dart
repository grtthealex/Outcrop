import 'package:flutter/material.dart';
import 'package:outcrop/data/data.dart';
import 'package:outcrop/models/product_card_model.dart';
import 'package:outcrop/pages/category.dart';
import 'package:outcrop/pages/favourites.dart';
import 'package:outcrop/pages/home.dart';
import 'package:outcrop/pages/profile.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  final Set<String> _favorites = {};

  void _toggleFavorite(ProductCardModel product) {
    setState(() {
      if (_favorites.contains(product.name)) {
        _favorites.remove(product.name);
      } else {
        _favorites.add(product.name);
      }
    });
  }

  int _currentIndex = 0;

  Widget _body() {
    switch (_currentIndex) {
      case 0:
        return HomeBody(
          key: ValueKey(_favorites.length),
          categories: categoriesList,
          products: products,
          favorites: _favorites,
          onToggleFavorite: _toggleFavorite,
          onCategoryTap: (String category) {
            // Pass _favorites and toggle function to Category page
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
            ).then((_) => setState(() {})); // refresh on return
          },
        );
      case 1:
        return FavouritesBody(
          key: ValueKey(_favorites.length),
          products: products,
          favorites: _favorites,
          onToggleFavorite: _toggleFavorite,
        );
      case 2:
      default:
        return const ProfileBody();
    }
  }

  final List<PreferredSizeWidget> _appbars = [
    HomeAppBar(),
    FavouritesAppBar(),
    ProfileAppBar(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbars[_currentIndex],
      body: _body(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFA8FB71),
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorite'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
