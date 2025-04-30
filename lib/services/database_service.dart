// services/database_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/loyalty_card.dart';

class DatabaseService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addCard(LoyaltyCard card) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');
    
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('cards')
        .add(card.toMap());
  }

  Stream<List<LoyaltyCard>> getCards() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');
    
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('cards')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return LoyaltyCard.fromMap(doc.id as Map<String, dynamic>, doc.data());
          }).toList();
        });
  }

  Future<void> deleteCard(String cardId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');
    
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('cards')
        .doc(cardId)
        .delete();
  }
}