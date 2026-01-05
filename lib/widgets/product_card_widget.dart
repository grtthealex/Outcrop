import 'package:flutter/material.dart';
import '../models/product_card_model.dart';

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
      width: 350,
      height: 180,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: const Color.fromARGB(255, 194, 193, 193),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: Colors.yellow,
              ),
              onPressed: onFavoriteToggle,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Image
              SizedBox(
                width: 150,
                height: 150,
                child: Image.asset(product.imagePath),
              ),

              const SizedBox(width: 30),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Name
                  Container(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      product.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Specification
                  Container(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      product.spec != null && product.spec!.isNotEmpty
                          ? product.spec!
                          : 'N/A',
                    ),
                  ),

                  SizedBox(height: 20),

                  Container(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text('₱${product.price.toStringAsFixed(2)}'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
