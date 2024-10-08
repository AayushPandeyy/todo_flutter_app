import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_firebase_app/enums/TaskCreationType.dart';
import 'package:todo_firebase_app/pages/AddOrUpdateTaskScreen.dart';
import 'package:todo_firebase_app/services/FirestoreService.dart';
import 'package:todo_firebase_app/utilities/ColorsToUse.dart';
import 'package:todo_firebase_app/widgets/taskScreen/TodoCard.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({super.key});

  @override
  State<TasksWidget> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksWidget> {
  @override
  Widget build(BuildContext context) {
    final firestoreService = Firestoreservice();
    final auth = FirebaseAuth.instance;
    return SafeArea(
        top: true,
        child: Scaffold(
          backgroundColor: ColorsToUse().primaryColor,
          body: StreamBuilder(
              stream:
                  firestoreService.getTasksBasedOnUser(auth.currentUser!.uid),
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
                        .map((data) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          AddOrUpdateTaskScreen(
                                              category: data["category"],
                                              dueDate:
                                                  data["dueDate"].toDate(),
                                              title: data["task"],
                                              todoId: data["uid"],
                                              type: Taskcreationtype.Update)));
                                },
                                child: TodoCard(
                                    status: data["completed"],
                                    todoId: data["uid"],
                                    dueDate: data["dueDate"],
                                    task: data["task"]),
                              ),
                            ))
                        .toList());
              }),
        ));
  }
}
