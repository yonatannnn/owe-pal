import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:owe_pal/models/amount.dart';

class AmountRepository {
  final CollectionReference _amountCollection =
      FirebaseFirestore.instance.collection('amounts');

  Future<void> addAmount(Amount amount) async {
    try {
      await _amountCollection.doc(amount.id).set(amount.toJson());
    } catch (e) {
      throw Exception('Error adding amount: $e');
    }
  }

  Future<void> updateAmount(Amount amount) async {
    try {
      await _amountCollection.doc(amount.id).update(amount.toJson());
    } catch (e) {
      throw Exception('Error updating amount: $e');
    }
  }

  Future<void> deleteAmount(String id) async {
    try {
      await _amountCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting amount: $e');
    }
  }

  Future<Amount?> getAmountById(String id) async {
    try {
      DocumentSnapshot doc = await _amountCollection.doc(id).get();
      if (doc.exists) {
        return Amount.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching amount: $e');
    }
  }

  Future<List<Amount>> getAmountsByGroupId(
      String groupId, String userId) async {
    try {
      QuerySnapshot snapshot =
          await _amountCollection.where('group_id', isEqualTo: groupId).get();
      List<Amount> allAmounts = snapshot.docs
          .map((doc) => Amount.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      List<Amount> userAmounts = allAmounts
          .where((amount) =>
              amount.id.split('_')[0] == userId ||
              amount.id.split('_')[1] == userId)
          .toList();

      return userAmounts;
    } catch (e) {
      throw Exception('Error fetching amounts: $e');
    }
  }
}
