import 'package:flutter/material.dart';
import 'package:todo_firebase_app/pages/categoryScreen/CompletedSpecificCategory.dart';
import 'package:todo_firebase_app/pages/categoryScreen/PendingSpecificCategory.dart';
import 'package:todo_firebase_app/utilities/ColorsToUse.dart';

class CategoryDataScreen extends StatefulWidget {
  final String category;
  const CategoryDataScreen({super.key, required this.category});

  @override
  State<CategoryDataScreen> createState() => _CategoryDataScreenState();
}

class _CategoryDataScreenState extends State<CategoryDataScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: ColorsToUse().primaryColor,
              iconTheme: IconThemeData(color: Colors.white),
              // centerTitle: true,
              titleSpacing: 0,
              title: Container(
                padding: const EdgeInsets.all(15),
                color: ColorsToUse().primaryColor,
                child: const TabBar(
                  dividerColor: Colors.transparent,
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(
                      text: 'Pending',
                    ),
                    Tab(
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
          body: TabBarView(children: [
            PendingSpecificCategory(
              category: widget.category,
            ),
            CompletedSpecificCategory(category: widget.category)
          ])),
    );
    ;
  }
}
