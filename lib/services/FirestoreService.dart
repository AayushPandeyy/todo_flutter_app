import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  Future<void> addTodo(
      String uid, task, category, DateTime dueDate, createdAt) async {
    String docId = uid + DateTime.now().toString();
    await firestore
        .collection('tasks')
        .doc(uid)
        .collection("todos")
        .doc(docId)
        .set({
      "uid": docId,
      'task': task,
      'completed': false,
      'category': category,
      'dueDate': dueDate,
      'createdDate': createdAt
    });
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

  Stream<List<Map<String, dynamic>>> getTasksBasedOnUserAndStatus(
      String uid, bool status) {
    return firestore
        .collection('tasks')
        .doc(uid)
        .collection('todos')
        .where("completed", isEqualTo: status)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final todo = doc.data();
        return todo;
      }).toList();
    });
  }

  Future<void> deleteTask(String todoId, uid) async {
    try {
      await firestore
          .collection('tasks')
          .doc(uid)
          .collection('todos')
          .doc(todoId)
          .delete();
    } catch (err) {
      print(err);
    }
  }

  Future<void> changeCompletedStatus(bool status, String todoId, uid) async {
    try {
      await firestore
          .collection('tasks')
          .doc(uid)
          .collection('todos')
          .doc(todoId)
          .update({"completed": status});
    } catch (e) {
      print(emptyTextSelectionControls);
    }
  }

  Future<void> updateTodoTask(String todoId, String uid, String task, category,
      DateTime dueDate) async {
    try {
      await firestore
          .collection('tasks')
          .doc(uid)
          .collection('todos')
          .doc(todoId)
          .update({"task": task, "category": category, "dueDate": dueDate});
    } catch (e) {}
  }
}
