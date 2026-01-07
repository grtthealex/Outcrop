import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:outcrop/models/category_card_model.dart';

class CategoryCardWidget extends StatelessWidget {
  final CategoryCardModel category;
  const CategoryCardWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 120,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromARGB(255, 194, 193, 193),
      ),
      child: Stack(
        children: [
          // Image
          Image.asset(
            category.imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            top: 24,
            left: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6), // blur container corners
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Text(
                    category.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Name
    );
    ;
  }
}
