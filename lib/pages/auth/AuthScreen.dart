import 'package:flutter/material.dart';
import 'package:todo_firebase_app/pages/auth/RegisterScreen.dart';
import 'package:todo_firebase_app/pages/auth/SignInScreen.dart';
import 'package:todo_firebase_app/utilities/ColorsToUse.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: ColorsToUse().primaryColor,
              // centerTitle: true,
              titleSpacing: 0,
              bottom: PreferredSize(
                preferredSize: Size(200, 50),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  color: ColorsToUse().primaryColor,
                  child: const TabBar(
                    dividerColor: Colors.transparent,
                    indicatorColor: Colors.black,
                    tabs: [
                      Tab(
                        text: 'Login',
                      ),
                      Tab(
                        text: 'Register',
                      ),
                    ],
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
              )),
          body: const TabBarView(children: [SignInScreen(), RegisterScreen()])),
    );
  }
}
