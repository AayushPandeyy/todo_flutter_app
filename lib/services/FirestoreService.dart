import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<void> addTodo(String uid, task) async {
    await firestore
        .collection('tasks')
        .doc(uid)
        .collection("todos")
        .add({'uid': uid, 'task': task, 'completed': false});
  }

  Stream<List<Map<String, dynamic>>> getTasksBasedOnUser(String uid) {
    return firestore
        .collection('tasks')
        .doc(uid)
        .collection('todos')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final todo = doc.data();
        return todo;
      }).toList();
    });
  }
}
