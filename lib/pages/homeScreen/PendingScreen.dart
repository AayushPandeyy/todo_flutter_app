import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_firebase_app/enums/TaskCreationType.dart';
import 'package:todo_firebase_app/pages/AddOrUpdateTaskScreen.dart';
import 'package:todo_firebase_app/services/FirestoreService.dart';
import 'package:todo_firebase_app/utilities/ColorsToUse.dart';
import 'package:todo_firebase_app/widgets/homeScreen/TodoCard.dart';

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
                                                type:
                                                    Taskcreationtype.Update)));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TodoCard(
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
