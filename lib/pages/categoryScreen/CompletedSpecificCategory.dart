import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_firebase_app/services/FirestoreService.dart';
import 'package:todo_firebase_app/utilities/ColorsToUse.dart';
import 'package:todo_firebase_app/widgets/taskScreen/TodoCard.dart';

class CompletedSpecificCategory extends StatefulWidget {
  final String category;
  const CompletedSpecificCategory({super.key, required this.category});

  @override
  State<CompletedSpecificCategory> createState() => _CompletedSpecificCategoryState();
}

class _CompletedSpecificCategoryState extends State<CompletedSpecificCategory> {
  @override
  Widget build(BuildContext context) {
   final firestoreService = Firestoreservice();
    final auth = FirebaseAuth.instance;
    return SafeArea(
        top: true,
        child: Scaffold(
          
          backgroundColor: ColorsToUse().primaryColor,
          body: StreamBuilder(
              stream: firestoreService.getTasksBasedOnUserAndCategoryAndStatus(
                  auth.currentUser!.uid, widget.category ,true),
              builder: (context, snapshot) {
                print(snapshot.data);

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