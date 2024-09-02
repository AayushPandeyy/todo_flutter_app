import 'package:flutter/material.dart';
import 'package:todo_firebase_app/pages/homeScreen/HomeScreen.dart';
import 'package:todo_firebase_app/pages/ProfileScreen.dart';
import 'package:todo_firebase_app/utilities/ColorsToUse.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedPage = 0;
  final pages = const [HomeScreen(), ProfileScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: ColorsToUse().secondaryColor,
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.white,
        currentIndex: selectedPage,
        unselectedIconTheme: const IconThemeData(color: Colors.white),
        selectedIconTheme: IconThemeData(color: ColorsToUse().secondaryColor),
        onTap: (index) {
          setState(() {
            selectedPage = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: "Profile",
          ),
        ],
      ),
      body: pages[selectedPage],
    );
  }
}
