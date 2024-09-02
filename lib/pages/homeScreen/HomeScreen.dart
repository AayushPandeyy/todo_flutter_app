import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_firebase_app/pages/AddTaskScreen.dart';
import 'package:todo_firebase_app/pages/homeScreen/CompletedScreen.dart';
import 'package:todo_firebase_app/pages/homeScreen/PendingScreen.dart';
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
              centerTitle: true,
              titleSpacing: 0,
              title: Container(
                padding: EdgeInsets.all(15),
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
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddTaskScreen()));
            },
            child: const Icon(Icons.add),
          ),
          body: TabBarView(children: [PendingScreen(), CompletedScreen()])),
    );
  }
}
