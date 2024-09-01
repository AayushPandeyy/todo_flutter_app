import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_firebase_app/pages/AddTaskScreen.dart';
import 'package:todo_firebase_app/pages/auth/SignInScreen.dart';
import 'package:todo_firebase_app/services/AuthFirebaseService.dart';
import 'package:todo_firebase_app/services/FirestoreService.dart';
import 'package:todo_firebase_app/utilities/ColorsToUse.dart';
import 'package:todo_firebase_app/widgets/homeScreen/TodoCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthFirebaseService authFirebaseService = AuthFirebaseService();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddTaskScreen()));
            },
            child: const Icon(Icons.add),
          ),
          backgroundColor: ColorsToUse().primaryColor,
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    authFirebaseService.logout();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInScreen()));
                  },
                  icon: Icon(Icons.logout))
            ],
          ),
          body: StreamBuilder(
              stream:
                  Firestoreservice().getTasksBasedOnUser(auth.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                    children: snapshot.data!
                        .map((data) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TodoCard(task: data["task"]),
                            ))
                        .toList());
              })),
    );
  }
}
