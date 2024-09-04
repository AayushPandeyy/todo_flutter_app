import 'package:flutter/material.dart';
import 'package:todo_firebase_app/pages/ScheduleScreen.dart';
import 'package:todo_firebase_app/pages/auth/SignInScreen.dart';
import 'package:todo_firebase_app/pages/taskScreens/TaskScreen.dart';
import 'package:todo_firebase_app/services/AuthFirebaseService.dart';
import 'package:todo_firebase_app/services/FirestoreService.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final firestoreService = Firestoreservice();
  final authService = AuthFirebaseService();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 2,
      width: MediaQuery.sizeOf(context).width,
      backgroundColor: Colors.black.withOpacity(0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DrawerTile(Icons.person, () {
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => const ProfileScreen()));
          }, "Profile"),
          DrawerTile(Icons.category, () {
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => const ProfileScreen()));
          }, "Categories"),
          DrawerTile(Icons.task_alt_outlined, () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const TaskScreen()));
          }, "Tasks"),
          DrawerTile(Icons.schedule, () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ScheduleScreen()));
          }, "Your Schedule"),
          DrawerTile(Icons.logout, () async {
            await authService.logout();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SignInScreen()));
          }, "Logout"),
          DrawerTile(Icons.close, () {
            Navigator.pop(context);
          }, "Close"),
        ],
      ),
    );
  }

  Widget DrawerTile(IconData icon, VoidCallback onPressed, String title) {
    return Column(
      children: [
        Container(
          height: 60,
          // color: Colors.white,
          child: GestureDetector(
            onTap: () {
              onPressed();
            },
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        fontFamily: "SpaceGrotesk",
                        fontSize: 30,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
