import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:todo_firebase_app/enums/TaskCreationType.dart';
import 'package:todo_firebase_app/pages/AddOrUpdateTaskScreen.dart';
import 'package:todo_firebase_app/services/FirestoreService.dart';
import 'package:todo_firebase_app/utilities/ColorsToUse.dart';
import 'package:todo_firebase_app/widgets/homeScreen/CustomDrawer.dart';

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
  Widget build(BuildContext context) {
    final Map<String, int> tasksCompletedPerDay = {
      "Mon": 3,
      "Tue": 5,
      "Wed": 2,
      "Thu": 7,
      "Fri": 4,
      "Sat": 6,
      "Sun": 1,
    };
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorsToUse().primaryColor,
            drawer: const CustomDrawer(),
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
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
                        final listOfCompletedTask = snapshot.data!
                            .where((data) => data["completed"] == true)
                            .toList();
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
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
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              addTaskWidget(),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  dataBox(
                                      "All Tasks", totalTasks, Icons.task_alt),
                                  dataBox("Completed",
                                      listOfCompletedTask.length, Icons.check),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  dataBox(
                                      "Incomplete",
                                      totalTasks - listOfCompletedTask.length,
                                      Icons.close),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child:
                                    Center(child: chart(tasksCompletedPerDay)),
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
    return Container(
      height: 90,
      width: 170,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontFamily: "Gabarito",
                      fontSize: 20,
                      color: Color.fromARGB(255, 216, 214, 214)),
                ),
                Text(
                  data.toString(),
                  style: const TextStyle(
                      fontFamily: "Gabarito",
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget chart(Map<String, int> tasksCompletedPerDay) {
    return LineChart(
      LineChartData(
        maxY: tasksCompletedPerDay.values
                .reduce((a, b) => a > b ? a : b)
                .toDouble() +
            1, // Maximum Y based on data
        minX: 0,
        minY: 0,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final day = tasksCompletedPerDay.keys.elementAt(value.toInt());
                return Text(day,
                    style: const TextStyle(color: Colors.grey, fontSize: 12));
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString(),
                    style: const TextStyle(color: Colors.grey, fontSize: 12));
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 1,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.3), strokeWidth: 1);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.3), strokeWidth: 1);
          },
        ),
        lineBarsData: [
          LineChartBarData(
            spots: tasksCompletedPerDay.entries
                .map((entry) => FlSpot(
                      tasksCompletedPerDay.keys
                          .toList()
                          .indexOf(entry.key)
                          .toDouble(),
                      entry.value.toDouble(),
                    ))
                .toList(),
            isCurved: true,
            dotData: FlDotData(show: true),
            color: Colors.blue,
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.3),
                  Colors.blue.withOpacity(0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
