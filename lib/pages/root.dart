import 'package:flutter/material.dart';
import 'package:outcrop/pages/favourites.dart';
import 'package:outcrop/pages/home.dart';
import 'package:outcrop/pages/profile.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _HomePageState();
}

class _HomePageState extends State<Root> {
  int _currentIndex = 0;

  final List<Widget> _body = [HomeBody(), FavouritesBody(), ProfileBody()];

  final List<PreferredSizeWidget> _appbars = [
    HomeAppBar(),
    FavouritesAppBar(),
    ProfileAppBar(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbars[_currentIndex],
      body: _body[_currentIndex],
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
