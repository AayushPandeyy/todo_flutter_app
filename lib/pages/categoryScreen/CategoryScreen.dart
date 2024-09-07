import 'package:flutter/material.dart';
import 'package:todo_firebase_app/pages/categoryScreen/CategoryDataScreen.dart';
import 'package:todo_firebase_app/utilities/Categories.dart';
import 'package:todo_firebase_app/utilities/ColorsToUse.dart';
import 'package:todo_firebase_app/widgets/categoryScreen/CategoryTile.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    List<Widget> children = Categories()
        .categoryIcons
        .entries
        .map((cat) => GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CategoryDataScreen(category: cat.key)));
            },
            child: CategoryTile(icon: cat.value, category: cat.key)))
        .toList();
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsToUse().primaryColor,
        title: const Text("Categories",
            style: TextStyle(
                fontSize: 40, fontFamily: "Debug", color: Colors.white)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: ColorsToUse().primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: children,
        ),
      ),
    ));
  }
}
