import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Firestoreservice {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getUserDataByEmail(String email) {
    return FirebaseFirestore.instance
        .collection('Users') // The name of your collection
        .where('email', isEqualTo: email)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  Future<void> addUserToDatabase(String uid, email, username) async {
    await firestore
        .collection("Users")
        .doc(uid)
        .set({'uid': uid, "email": email, "username": username});
  }
}
