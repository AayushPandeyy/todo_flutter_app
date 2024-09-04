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
        .orderBy('dueDate')
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

  Future<void> addWhenCompleted(
      String task,
      category,
      DateTime dueDate,
      DateTime createdDate,
      DateTime completedDate,
      String todoId,
      String uid) async {
    try {
      await firestore
          .collection('CompletedTasks')
          .doc(uid)
          .collection(completedDate.toString())
          .doc()
          
          .set({
        "task": task,
        "category": category,
        "dueDate": dueDate,
        "createdDate": createdDate,
        "uid": todoId,
        "completedDate": completedDate
      });
    } catch (e) {}
  }

Future<Map<String, int>> getCompletedTasksCountByDate(String uid) async {

  // Initialize the map to store counts of completed tasks by date
  final Map<String, int> tasksCompletedByDate = {};

  // Fetch all documents from the 'todos' collection for the specified user
  final snapshot = await firestore
      .collection('tasks')
      .doc(uid)
      .collection('todos')
      .get();

  // Iterate over each document in the snapshot
  for (var doc in snapshot.docs) {
    final data = doc.data();

    // Check if the task is marked as completed
    if (data['completed'] == true && data['completedOn'] != null) {
      // Convert the Firestore Timestamp to DateTime
      final completedOnDate = (data['completedOn'] as Timestamp).toDate();

      // Normalize the date to just the date part (midnight)
      final normalizedDate = DateTime(
        completedOnDate.year,
        completedOnDate.month,
        completedOnDate.day,
      );

      // Increment the count of tasks completed on this normalized date
      if (tasksCompletedByDate.containsKey(normalizedDate)) {
        tasksCompletedByDate[normalizedDate.toString()] = tasksCompletedByDate[normalizedDate]! + 1;
      } else {
        tasksCompletedByDate[normalizedDate.toString()] = 1;
      }
    }
  }

  // Return the map with counts of completed tasks by date
  return tasksCompletedByDate;
}

  
}
