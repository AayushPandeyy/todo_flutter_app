import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_firebase_app/services/FirestoreService.dart';
import 'package:todo_firebase_app/utilities/ColorsToUse.dart';

class TodoCard extends StatefulWidget {
  final String todoId;
  final String task;
  const TodoCard({super.key, required this.task, required this.todoId});

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  final firestoreService = Firestoreservice();
  final auth = FirebaseAuth.instance;
  bool completed = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorsToUse().secondaryColor),
      child: Row(
        children: [
          Checkbox(
            value: completed,
            onChanged: (value) async {
              setState(() {
                completed = value!;
              });
              await firestoreService.changeCompletedStatus(
                  completed, widget.todoId, auth.currentUser!.uid);
            },
            checkColor: ColorsToUse().secondaryColor,
            activeColor: Colors.black,
          ),
          Expanded(
            child: Text(
              widget.task,
              style: const TextStyle(
                  fontFamily: "Gabarito",
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.black),
              child: Center(
                  child: IconButton(
                onPressed: () async {
                  print("peress");
                  try {
                    await firestoreService.deleteTask(
                        widget.todoId, auth.currentUser!.uid);
                  } catch (e) {
                    print(e);
                  }
                },
                icon: const Icon(Icons.delete),
                color: Colors.red,
              ))),
          const SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }
}
