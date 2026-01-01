import 'package:flutter/material.dart';

class FavouritesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FavouritesAppBar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(56);
  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text('Favourites'));
  }
}

class FavouritesBody extends StatelessWidget {
  const FavouritesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
