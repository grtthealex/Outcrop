import 'package:flutter/material.dart';
import 'package:outcrop/models/product_card_model.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductCardModel product;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const ProductCardWidget({
    super.key,
    required this.product,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      width: 400,
      height: 130,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0xFFA8FB71).withAlpha(50),
            offset: const Offset(0, 4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
        borderRadius: BorderRadius.circular(12),
        color: Color(0xFFA8FB71),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Color(0xFFFFFED2),
                border: Border.all(
                  color: const Color.fromARGB(223, 203, 182, 19),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: Stack(
                  children: [
                    Icon(
                      isFavorite ? Icons.star : Icons.star_border,
                      size: 25,
                      color: Colors.yellow,
                    ),
                    Icon(
                      Icons.star_border,
                      size: 25,
                      color: const Color.fromARGB(223, 203, 182, 19),
                    ),
                  ],
                ),
                onPressed: onFavoriteToggle,
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 10,
            child: Container(
              padding: EdgeInsets.only(left: 8, right: 8),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                '₱${product.price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Name
              Container(
                constraints: BoxConstraints(maxWidth: 200),
                padding: EdgeInsets.only(left: 14, right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  product.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),

              SizedBox(height: 20),

              // Specification
              Container(
                padding: EdgeInsets.only(left: 8, right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Spec: ${product.spec != null && product.spec!.isNotEmpty ? product.spec! : 'N/A'}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
