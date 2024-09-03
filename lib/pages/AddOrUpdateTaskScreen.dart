import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_firebase_app/enums/TaskCreationType.dart';
import 'package:todo_firebase_app/services/FirestoreService.dart';
import 'package:todo_firebase_app/utilities/ColorsToUse.dart';
import 'package:todo_firebase_app/widgets/common/CustomButton.dart';
import 'package:todo_firebase_app/widgets/common/CustomTextField.dart';

class AddOrUpdateTaskScreen extends StatefulWidget {
  final String? title;
  final Enum type;
  final String? todoId;
  const AddOrUpdateTaskScreen(
      {super.key, required this.type, this.title, this.todoId});

  @override
  State<AddOrUpdateTaskScreen> createState() => _AddOrUpdateTaskScreenState();
}

class _AddOrUpdateTaskScreenState extends State<AddOrUpdateTaskScreen> {
  final taskController = TextEditingController();
  final firestoreService = Firestoreservice();
  final auth = FirebaseAuth.instance;

  void addTodo() async {
    await firestoreService.addTodo(auth.currentUser!.uid, taskController.text);
  }

  void updateTodo() async {
    await firestoreService.updateTodoTask(
        widget.todoId!, auth.currentUser!.uid, taskController.text);
  }

  @override
  Widget build(BuildContext context) {
    bool isAdd = widget.type == Taskcreationtype.Add;

    return SafeArea(
        child: Scaffold(
      backgroundColor: ColorsToUse().primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(isAdd ? "Add a new task" : "Update Task",
              style: const TextStyle(
                  color: Colors.grey,
                  fontFamily: "Gabarito",
                  fontSize: 40,
                  fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextField(
              title: widget.title,
              placeholder: "New Task",
              controller: taskController,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomButton(
              text: isAdd ? "Add" : "Update",
              onPress: () async {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(isAdd ? "Adding Task" : "Updating Task"),
                              const SizedBox(
                                width: 15,
                              ),
                              const CircularProgressIndicator()
                            ],
                          ),
                        ));
                isAdd ? addTodo() : updateTodo();
                Navigator.pop(context);
                Navigator.pop(context);
              })
        ],
      ),
    ));
  }
}
