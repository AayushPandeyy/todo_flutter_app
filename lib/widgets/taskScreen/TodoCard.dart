import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_firebase_app/services/FirestoreService.dart';
import 'package:todo_firebase_app/utilities/ColorsToUse.dart';

class TodoCard extends StatefulWidget {
  final bool status;
  final String todoId;
  final String task;
  final Timestamp? dueDate;
  const TodoCard(
      {super.key,
      required this.task,
      required this.todoId,
      required this.status,
      this.dueDate});

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
      height: 70,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorsToUse().secondaryColor),
      child: Row(
        children: [
          Checkbox(
            value: widget.status,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.task,
                  style: TextStyle(
                      decoration: widget.status
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      fontFamily: "Gabarito",
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Due Date : ${DateFormat('d MMMM yyyy').format(widget.dueDate!.toDate())}",
                  style: TextStyle(
                      decoration: widget.status
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      fontFamily: "Gabarito",
                      fontSize: 15,
                      color:
                          DateTime.now().difference(widget.dueDate!.toDate()) <
                                  Duration(days: 1)
                              ? Colors.green
                              : Colors.red,
                      fontWeight: FontWeight.bold),
                ),
              ],
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
