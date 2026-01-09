import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_card_model.dart';

class ProductService {
  // Existing fetch method - PRESERVED UNCHANGED
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

  // Batch Upload: Logic ported from your original Python script
  static Future<void> uploadBatch(
    String date,
    List<ProductCardModel> products,
  ) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final WriteBatch batch = firestore.batch();
    final collection = firestore.collection(date);

    // 1. Clear existing data to prevent duplicates for that date
    final existingDocs = await collection.get();
    for (var doc in existingDocs.docs) {
      batch.delete(doc.reference);
    }

    // 2. Map extracted products to Firestore document format
    for (var product in products) {
      final docRef = collection.doc();
      batch.set(docRef, {
        'name': product.name,
        'spec': product.spec,
        'price': product.price,
        'category': product.category,
      });
    }

    // 3. Atomically commit the batch
    await batch.commit();
  }
}
