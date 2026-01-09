import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/comment_model.dart';

class CommentService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream of comments for a specific product name
  // lib/services/comment_service.dart

// lib/services/comment_service.dart

Stream<List<ProductComment>> getComments(String productName) {
  return _db
      .collection('product_comments')
      .where('productName', isEqualTo: productName)
      .orderBy('timestamp', descending: true)
      // includeMetadataChanges ensures the comment stays visible while uploading
      .snapshots(includeMetadataChanges: true) 
      .map((snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return ProductComment.fromFirestore(data);
          }).toList());
}

  // Add a new comment
  Future<void> addComment(String productName, String text) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || text.trim().isEmpty) return;

    await _db.collection('product_comments').add({
      'productName': productName,
      'userName': user.displayName ?? user.email?.split('@')[0] ?? 'User',
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}