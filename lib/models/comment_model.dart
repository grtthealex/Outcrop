import 'package:cloud_firestore/cloud_firestore.dart';

class ProductComment {
  final String userName;
  final String text;
  final DateTime timestamp;

  ProductComment({
    required this.userName,
    required this.text,
    required this.timestamp,
  });


factory ProductComment.fromFirestore(Map<String, dynamic> data) {
  return ProductComment(
    userName: data['userName'] ?? 'Anonymous',
    text: data['text'] ?? '',
    // Use the local time if the server timestamp hasn't arrived yet
    timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );
}
  
}