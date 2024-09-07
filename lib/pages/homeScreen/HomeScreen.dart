import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_firebase_app/admob/CustomBannerAd.dart';
import 'package:todo_firebase_app/enums/TaskCreationType.dart';
import 'package:todo_firebase_app/pages/AddOrUpdateTaskScreen.dart';
import 'package:todo_firebase_app/services/FirestoreService.dart';
import 'package:todo_firebase_app/utilities/ColorsToUse.dart';
import 'package:todo_firebase_app/widgets/homeScreen/CustomDrawer.dart';
import 'package:todo_firebase_app/widgets/homeScreen/CustomLineGraph.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  final firestoreService = Firestoreservice();
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
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorsToUse().primaryColor,
            drawer: const CustomDrawer(),
            appBar: AppBar(
              title: const Text("Taskopia",
                  style: TextStyle(
                      fontSize: 40, fontFamily: "Debug", color: Colors.white)),
              centerTitle: true,
              iconTheme: const IconThemeData(
                color: Colors.white,
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

                        int totalTasks = snapshot.data!.length;
                        final numberOfCompletedTask = snapshot.data!
                            .where((data) => data["completed"] == true)
                            .toList()
                            .length;
                        final numberOfTasksDueToday = snapshot.data!
                            .where((data) => (DateFormat('d MMMM yyyy').format(
                                        (data["dueDate"] as Timestamp)
                                            .toDate()) ==
                                    DateFormat('d MMMM yyyy')
                                        .format(DateTime.now()) &&
                                data["completed"] == false))
                            .toList()
                            .length;
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                determineTimeOfDay(),
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "MarkoOne",
                                    color: Colors.white),
                              ),
                              Text(
                                username,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: "MarkoOne",
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              addTaskWidget(),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  dataBox(
                                      "All Tasks", totalTasks, Icons.task_alt),
                                  dataBox("Completed", numberOfCompletedTask,
                                      Icons.check),
                                  dataBox(
                                      "Incomplete",
                                      totalTasks - numberOfCompletedTask,
                                      Icons.close),
                                  dataBox("Due Today", numberOfTasksDueToday,
                                      Icons.today),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: Center(child: BannerAdWidget()),
                              )
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
          color: ColorsToUse().secondaryColor,
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
                    fontFamily: "Gabarito",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "You can create new task here",
                  style: TextStyle(
                    fontFamily: "Gabarito",
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  color: ColorsToUse().primaryColor,
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
                    color: Colors.white,
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

  Widget dataBox(String title, int data, IconData icon) {
    return Column(
      children: [
        Container(
          height: 70,
          width: MediaQuery.sizeOf(context).width * 0.91,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(
                width: 10,
              ),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(20)),
                child: Icon(icon),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontFamily: "Gabarito",
                        fontSize: 20,
                        color: Color.fromARGB(255, 216, 214, 214)),
                  ),
                ),
              ),
              Text(
                data.toString(),
                style: const TextStyle(
                    fontFamily: "Gabarito",
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 20,
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
