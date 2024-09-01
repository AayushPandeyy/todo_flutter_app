import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_firebase_app/services/FirestoreService.dart';
import 'package:todo_firebase_app/widgets/common/CustomButton.dart';
import 'package:todo_firebase_app/widgets/common/CustomTextField.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final taskController = TextEditingController();
  final firestoreService = Firestoreservice();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        // height: MediaQuery.sizeOf(context).height * 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Add a new task",
                style: TextStyle(
                    fontFamily: "Gabarito",
                    fontSize: 40,
                    fontWeight: FontWeight.bold)),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomTextField(
                placeholder: "New Task",
                controller: taskController,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CustomButton(
                text: "Add",
                onPress: () async {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Adding Task"),
                                SizedBox(
                                  width: 15,
                                ),
                                CircularProgressIndicator()
                              ],
                            ),
                          ));
                  await firestoreService.addTodo(
                      auth.currentUser!.uid, taskController.text);
                  Navigator.pop(context);
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    ));
  }
}
