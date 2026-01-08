import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavouriteService {
  static final _firestore = FirebaseFirestore.instance;

  /// Fetch user's favorites from Firestore
  static Future<Set<String>> getUserFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    final doc = await _firestore
        .collection('user_favorites')
        .doc(user.uid)
        .get();
    if (!doc.exists) return {};

    final favs = List<String>.from(doc.data()?['favorites'] ?? []);
    return favs.toSet();
  }

  /// Update user's favorites in Firestore
  static Future<void> updateUserFavorites(Set<String> favorites) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _firestore.collection('user_favorites').doc(user.uid).set({
      'favorites': favorites.toList(),
    }, SetOptions(merge: true));
  }
}
