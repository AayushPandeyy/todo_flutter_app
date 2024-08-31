import 'package:flutter/material.dart';
import 'package:todo_firebase_app/pages/auth/SignInScreen.dart';
import 'package:todo_firebase_app/services/AuthFirebaseService.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthFirebaseService authFirebaseService = AuthFirebaseService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
        body: Center(
          child: Text("Home Screen"),
        ),
      ),
    );
  }
}
