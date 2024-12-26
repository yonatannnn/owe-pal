import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/group.dart';

class GroupRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'groups';

  Future<void> createGroup(Group group) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(group.id)
          .set(group.toJson());
    } catch (e) {
      throw Exception('Error creating group: $e');
    }
  }

  Future<Group?> getGroup(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(collectionPath).doc(id).get();
      if (doc.exists) {
        return Group.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting group: $e');
    }
  }

  Future<void> updateGroup(Group group) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(group.id)
          .update(group.toJson());
    } catch (e) {
      throw Exception('Error updating group: $e');
    }
  }

  Future<void> deleteGroup(String id) async {
    try {
      await _firestore.collection(collectionPath).doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting group: $e');
    }
  }

  Future<void> addUserToGroup(String groupId, String userId) async {
    try {
      DocumentReference groupRef =
          _firestore.collection(collectionPath).doc(groupId);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(groupRef);
        if (!snapshot.exists) {
          throw Exception('Group does not exist!');
        }

        List<String> usersId = List<String>.from(snapshot['usersId']);
        if (!usersId.contains(userId)) {
          usersId.add(userId);
          transaction.update(groupRef, {'usersId': usersId});
        }
      });
    } catch (e) {
      throw Exception('Error adding user to group: $e');
    }
  }

  Future<List<Group>> getAllGroups() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(collectionPath).get();
      return querySnapshot.docs
          .map((doc) => Group.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error getting all groups: $e');
    }
  }
}
