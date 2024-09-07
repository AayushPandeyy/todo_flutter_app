import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_firebase_app/services/FirestoreService.dart';
import 'package:todo_firebase_app/utilities/ColorsToUse.dart';
import 'package:todo_firebase_app/widgets/taskScreen/TodoCard.dart';

class DisplayTasksScreen extends StatefulWidget {
  final Stream dataStream;
  const DisplayTasksScreen({super.key, required this.dataStream});

  @override
  State<DisplayTasksScreen> createState() => _DisplayTasksScreenState();
}

class _DisplayTasksScreenState extends State<DisplayTasksScreen> {
  @override
  Widget build(BuildContext context) {

    return SafeArea(
        top: true,
        child: Scaffold(
          backgroundColor: ColorsToUse().primaryColor,
          body: StreamBuilder(
              stream: widget.dataStream,
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
                              child: TodoCard(
                                  status: data["completed"],
                                  todoId: data["uid"],
                                  task: data["task"]),
                            ))
                        .toList());
              }),
        ));
  }
}