import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_firebase_app/services/FirestoreService.dart';
import 'package:todo_firebase_app/utilities/ColorsToUse.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    Firestoreservice service = Firestoreservice();
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0xffE9EBFF),
      body: StreamBuilder(
          stream: service.getUserDataByEmail(auth.currentUser!.email!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            String username =
                snapshot.data!.map((snapshot) => snapshot["username"]).first;
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                            "https://s3-alpha-sig.figma.com/img/ad02/30e5/1cf72c468f60f22a06ee0b26b40e974f?Expires=1729468800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=jL5J1WXP9qFIWNaMmY-CTGK~fUFUlbx3UOUIFMPFKLLISoewuuuu7AG~YwkrbFFAr-WeM5Lo79rWHroSZp04VpiMEZfeRwjNaGQceilrT~K3mbw8A1CCFODIxerRwLFYCcql8rYVVnyyMHsBZaaOr2BwyOcDmH2s-VQFtkIX8BVW~YYCPTbEI8i2SfvlcLRr4BIc8XPL3ffoeoKHcHd8hg-1o5JT9Dqpztwqa77dmbNoTAZWIFpFHkOpgUrG2rXqSnshGK323XoiEWgejv6bsA~3-NT3XGyBqBelyY-mLt~M9seOpN8fLf8pm1mrGu1Q~1pc~2ZY22H6Yvv5S3m1ug__"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        username,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.3,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                CupertinoIcons.exclamationmark_octagon,
                                color: Colors.white,
                              ),
                              Text(
                                "Remove Ads",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            height: MediaQuery.sizeOf(context).height * 0.25,
                            width: MediaQuery.sizeOf(context).width * 0.45,
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Daily",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Icon(CupertinoIcons.calendar)
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Stack(children: [
                                    Center(
                                      child: PieChart(
                                        PieChartData(
                                          sectionsSpace:
                                              0, // No space between sections
                                          centerSpaceRadius:
                                              50, // Radius of the center hole
                                          sections: [
                                            PieChartSectionData(
                                                color: Colors.purple,
                                                value: 4,
                                                radius: 5,
                                                showTitle: false),
                                            PieChartSectionData(
                                              color: Colors.transparent,
                                              value: 1,
                                              showTitle: false,
                                              radius: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "4/5",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "80%",
                                          style: TextStyle(color: Colors.grey),
                                        )
                                      ],
                                    ))
                                  ]),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            height: MediaQuery.sizeOf(context).height * 0.25,
                            width: MediaQuery.sizeOf(context).width * 0.45,
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Priorities",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Icon(Icons.crisis_alert_sharp)
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: ColorsToUse().primaryColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("1"),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text("High")
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: ColorsToUse().primaryColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("1"),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text("Medium")
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: ColorsToUse().primaryColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("0"),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text("Low")
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: ColorsToUse().primaryColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text("0"),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text("Extras")
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ProfileBox("Personal Information", Icons.person),
                      const SizedBox(
                        height: 5,
                      ),
                      ProfileBox("Completed Task", Icons.edit_calendar_rounded),
                      const SizedBox(
                        height: 5,
                      ),
                      ProfileBox("Calendar", Icons.calendar_month),
                      const SizedBox(
                        height: 5,
                      ),
                      ProfileBox("Sync", Icons.cloud),
                      const SizedBox(
                        height: 5,
                      ),
                      ProfileBox("Share With Friends", Icons.send),
                      const SizedBox(
                        height: 5,
                      ),
                      ProfileBox("Rate Us", CupertinoIcons.star)
                    ],
                  ),
                ),
              ),
            );
          }),
    ));
  }
}

// ignore: non_constant_identifier_names
Widget ProfileBox(String title, IconData icon) {
  return Container(
    height: 50,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: Colors.white),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    ),
  );
}
