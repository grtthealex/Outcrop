import 'package:flutter/material.dart';

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

class FavouritesBody extends StatefulWidget {
  const FavouritesBody({super.key});

  @override
  State<FavouritesBody> createState() => _FavouritesBodyState();
}

class _FavouritesBodyState extends State<FavouritesBody> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
