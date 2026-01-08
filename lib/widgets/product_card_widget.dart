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
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
        color: Color.fromARGB(255, 175, 239, 133),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(
                size: 30,
                isFavorite ? Icons.star : Icons.star_border,
                color: Colors.yellow,
              ),
              onPressed: onFavoriteToggle,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 10,
            child: Container(
              padding: EdgeInsets.only(left: 8, right: 8),
              decoration: BoxDecoration(
                color: Colors.white,
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
                  color: Colors.white,
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
                  color: Colors.white,
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
