import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_firebase_app/enums/TaskCreationType.dart';
import 'package:todo_firebase_app/pages/AddOrUpdateTaskScreen.dart';
import 'package:todo_firebase_app/pages/taskScreens/CompletedScreen.dart';
import 'package:todo_firebase_app/pages/taskScreens/PendingScreen.dart';
import 'package:todo_firebase_app/services/AuthFirebaseService.dart';
import 'package:todo_firebase_app/utilities/ColorsToUse.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final AuthFirebaseService authFirebaseService = AuthFirebaseService();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
              centerTitle: true,
              titleSpacing: 0,
              title: Container(
                padding: const EdgeInsets.all(15),
                color: ColorsToUse().primaryColor,
                child: const TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(
                        Icons.incomplete_circle,
                        size: 24.0,
                        color: Colors.blueAccent,
                      ),
                      text: 'Pending',
                    ),
                    Tab(
                      icon: Icon(
                        Icons.check,
                        size: 24.0,
                        color: Colors.green,
                      ),
                      text: 'Completed',
                    ),
                  ],
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              )),
          
          body:
              const TabBarView(children: [PendingScreen(), CompletedScreen()])),
    );
  }
}
