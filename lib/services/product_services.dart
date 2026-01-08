import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_card_model.dart';

class ProductService {
  static Future<List<ProductCardModel>> fetchProductsByDate(String date) async {
    final snapshot = await FirebaseFirestore.instance.collection(date).get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return ProductCardModel(
        name: data['name'],
        spec: data['spec'],
        price: (data['price'] as num).toDouble(),
        category: data['category'],
      );
    }).toList();
  }
}
