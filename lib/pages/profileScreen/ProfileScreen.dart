import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_firebase_app/admob/CustomBannerAd.dart';
import 'package:todo_firebase_app/pages/profileScreen/DisplayTasksScreen.dart';
import 'package:todo_firebase_app/services/FirestoreService.dart';
import 'package:todo_firebase_app/utilities/ColorsToUse.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final auth = FirebaseAuth.instance;
  final firestoreService = Firestoreservice();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: ColorsToUse().primaryColor,
          body: StreamBuilder(
              stream:
                  firestoreService.getTasksBasedOnUser(auth.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
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
                                (data["dueDate"] as Timestamp).toDate()) ==
                            DateFormat('d MMMM yyyy').format(DateTime.now()) &&
                        data["completed"] == false))
                    .toList()
                    .length;
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          dataBox(
                              "All Tasks",
                              totalTasks,
                              Icons.task_alt,
                              firestoreService
                                  .getTasksBasedOnUser(auth.currentUser!.uid)),
                          dataBox(
                              "Completed",
                              numberOfCompletedTask,
                              Icons.check,
                              firestoreService.getTasksBasedOnUserAndStatus(
                                  auth.currentUser!.uid, true)),
                          dataBox(
                              "Incomplete",
                              totalTasks - numberOfCompletedTask,
                              Icons.close,
                              firestoreService.getTasksBasedOnUserAndStatus(
                                  auth.currentUser!.uid, false)),
                          dataBox(
                              "Due Today",
                              numberOfTasksDueToday,
                              Icons.today,
                              firestoreService
                                  .getTasksDueToday(auth.currentUser!.uid))
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
              })),
    );
  }

  Widget dataBox(String title, int data, IconData icon,
      Stream<List<Map<String, dynamic>>> stream) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DisplayTasksScreen(
                      dataStream: stream,
                      title: title,
                    )));
      },
      child: Column(
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
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20)),
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
      ),
    );
  }
}
