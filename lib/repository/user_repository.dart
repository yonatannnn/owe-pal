import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:owe_pal/models/user.dart' as user_model;

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(user_model.User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toJson());
    } catch (e) {
      throw Exception('Error adding user: $e');
    }
  }

  Future<user_model.User?> getUser(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return user_model.User.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting user: $e');
    }
  }

  Future<void> updateUser(user_model.User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).update(user.toJson());
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }

  String? getCurrentUserId() {
    final User? currentUser = _auth.currentUser;
    return currentUser?.uid;
  }
}
