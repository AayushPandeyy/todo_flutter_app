import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_firebase_app/admob/CustomBannerAd.dart';
import 'package:todo_firebase_app/enums/TaskCreationType.dart';
import 'package:todo_firebase_app/pages/AddOrUpdateTaskScreen.dart';
import 'package:todo_firebase_app/pages/profileScreen/ProfileScreen.dart';
import 'package:todo_firebase_app/services/FirestoreService.dart';
import 'package:todo_firebase_app/utilities/ColorsToUse.dart';
import 'package:todo_firebase_app/widgets/common/CustomTextField.dart';
import 'package:todo_firebase_app/widgets/homeScreen/CustomDrawer.dart';
import 'package:todo_firebase_app/widgets/taskScreen/TodoCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final auth = FirebaseAuth.instance;
  final firestoreService = Firestoreservice();
  late TabController _tabController;
  String determineTimeOfDay() {
    DateTime now = DateTime.now();
    if (now.hour <= 12) {
      return "Good Morning";
    } else if (now.hour > 12 && now.hour <= 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorsToUse().primaryColor,
            drawer: const CustomDrawer(),
            appBar: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfileScreen()));
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://s3-alpha-sig.figma.com/img/ad02/30e5/1cf72c468f60f22a06ee0b26b40e974f?Expires=1729468800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=jL5J1WXP9qFIWNaMmY-CTGK~fUFUlbx3UOUIFMPFKLLISoewuuuu7AG~YwkrbFFAr-WeM5Lo79rWHroSZp04VpiMEZfeRwjNaGQceilrT~K3mbw8A1CCFODIxerRwLFYCcql8rYVVnyyMHsBZaaOr2BwyOcDmH2s-VQFtkIX8BVW~YYCPTbEI8i2SfvlcLRr4BIc8XPL3ffoeoKHcHd8hg-1o5JT9Dqpztwqa77dmbNoTAZWIFpFHkOpgUrG2rXqSnshGK323XoiEWgejv6bsA~3-NT3XGyBqBelyY-mLt~M9seOpN8fLf8pm1mrGu1Q~1pc~2ZY22H6Yvv5S3m1ug__"),
                    ),
                  ),
                )
              ],
              title: const Text("Task Mate",
                  style: TextStyle(
                      fontSize: 40,
                      fontFamily: "Debug",
                      color: Colors.black87)),
              centerTitle: true,
              iconTheme: const IconThemeData(
                color: Colors.black87,
              ),
              backgroundColor: ColorsToUse().primaryColor,
            ),
            body: StreamBuilder(
                stream: firestoreService
                    .getUserDataByEmail(auth.currentUser!.email!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  String username = snapshot.data!
                      .map((snapshot) => snapshot["username"])
                      .first;
                  return StreamBuilder(
                      stream: firestoreService
                          .getTasksBasedOnUser(auth.currentUser!.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomTextField(
                                  placeholder: "Search Tasks"),
                              const SizedBox(
                                height: 20,
                              ),
                              addTaskWidget(),
                              const SizedBox(
                                height: 10,
                              ),
                              Center(child: BannerAdWidget()),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "TODO Items",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    "Status",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                  child: ListView(
                                      children: snapshot.data!
                                          .map((data) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => AddOrUpdateTaskScreen(
                                                                todoId:
                                                                    data["uid"],
                                                                title: data[
                                                                    "task"],
                                                                dueDate: (data[
                                                                            "dueDate"]
                                                                        as Timestamp)
                                                                    .toDate(),
                                                                category: data[
                                                                    "category"],
                                                                type: Taskcreationtype
                                                                    .Update)));
                                                  },
                                                  child: TodoCard(
                                                      status: data["completed"],
                                                      todoId: data["uid"],
                                                      dueDate: data["dueDate"],
                                                      task: data["task"]),
                                                ),
                                              ))
                                          .toList()))
                            ],
                          ),
                        );
                      });
                })));
  }

  Widget addTaskWidget() {
    return Container(
      height: 80,
      width: MediaQuery.sizeOf(context).width * 0.91,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 109, 32, 26),
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create new task",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Gabarito",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "You can create new task here",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Gabarito",
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100)),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddOrUpdateTaskScreen(
                                  type: Taskcreationtype.Add,
                                )));
                  },
                  icon: const Icon(
                    color: Colors.black87,
                    Icons.add,
                    size: 25,
                    fill: 1,
                    weight: 10,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
