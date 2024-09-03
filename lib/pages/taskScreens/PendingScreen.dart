import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_firebase_app/enums/TaskCreationType.dart';
import 'package:todo_firebase_app/pages/AddOrUpdateTaskScreen.dart';
import 'package:todo_firebase_app/services/FirestoreService.dart';
import 'package:todo_firebase_app/utilities/ColorsToUse.dart';
import 'package:todo_firebase_app/widgets/taskScreen/TodoCard.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({super.key});

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  @override
  Widget build(BuildContext context) {
    final firestoreService = Firestoreservice();
    final auth = FirebaseAuth.instance;
    return SafeArea(
        top: true,
        child: Scaffold(
          backgroundColor: ColorsToUse().primaryColor,
          body: StreamBuilder(
              stream: firestoreService.getTasksBasedOnUserAndStatus(
                  auth.currentUser!.uid, false),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Tasks",
                      style: TextStyle(fontSize: 30, color: Colors.grey),
                    ),
                  );
                }
                return ListView(
                    children: snapshot.data!
                        .map((data) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddOrUpdateTaskScreen(
                                                todoId: data["uid"],
                                                title: data["task"],
                                                dueDate: data["dueDate"],
                                                category: data["category"],
                                                type:
                                                    Taskcreationtype.Update)));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TodoCard(
                                  dueDate: data["dueDate"],
                                    status: data["completed"],
                                    todoId: data["uid"],
                                    task: data["task"]),
                              ),
                            ))
                        .toList());
              }),
        ));
  }
}
