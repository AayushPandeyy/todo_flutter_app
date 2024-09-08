import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:todo_firebase_app/enums/TaskCreationType.dart';
import 'package:todo_firebase_app/pages/AddOrUpdateTaskScreen.dart';
import 'package:todo_firebase_app/services/FirestoreService.dart';
import 'package:todo_firebase_app/utilities/ColorsToUse.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<Appointment> _appointments = <Appointment>[];

  @override
  void initState() {
    super.initState();
  }

  DateTime _selectedDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return SafeArea(
        child: Scaffold(
      backgroundColor: ColorsToUse().primaryColor,
      appBar: AppBar(
        backgroundColor: ColorsToUse().primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddOrUpdateTaskScreen(type: Taskcreationtype.Add)));
            },
          )
        ],
        title: const Text("Your Schedule",
            style: TextStyle(
                fontSize: 40, fontFamily: "Debug", color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: StreamBuilder(
            stream: Firestoreservice()
                .getTasksBasedOnUserAndStatus(auth.currentUser!.uid, false),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              _appointments = snapshot.data!
                  .map((snap) => Appointment(
                      id: snap["uid"],
                      startTime: (snap["dueDate"] as Timestamp).toDate(),
                      endTime: (snap["dueDate"] as Timestamp).toDate(),
                      isAllDay: true,
                      subject: snap["task"],
                      notes: snap["category"],
                      color: Colors.green))
                  .toList();
              return SfCalendar(
                headerStyle: CalendarHeaderStyle(
                    backgroundColor: ColorsToUse().primaryColor,
                    textStyle: TextStyle(color: Colors.white)),
                backgroundColor: ColorsToUse().primaryColor,
                allowAppointmentResize: true,
                view: CalendarView.schedule,
                showTodayButton: true,
                scheduleViewSettings: const ScheduleViewSettings(
                    dayHeaderSettings: DayHeaderSettings(
                        dateTextStyle: TextStyle(color: Colors.grey),
                        dayTextStyle: TextStyle(color: Colors.grey),
                        width: 60),
                    monthHeaderSettings: MonthHeaderSettings(height: 50),
                    appointmentItemHeight: 40,
                    appointmentTextStyle:
                        TextStyle(fontSize: 18, fontFamily: "UbuntuMono")),
                scheduleViewMonthHeaderBuilder: (context, details) {
                  return Container(
                    margin: EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 233, 217, 217),
                    ),
                    // height: 50,
                    child: Center(
                      child: Text(
                        DateFormat('MMMM yyyy').format(details.date),
                        style:
                            TextStyle(fontSize: 25, fontFamily: "UbuntuMono"),
                      ),
                    ),
                  );
                },
                allowedViews: const [
                  CalendarView.timelineMonth,
                  CalendarView.timelineWeek,
                  CalendarView.month
                ],
                initialSelectedDate: _selectedDay,
                dataSource: EventDataSource(_appointments),
                onTap: (CalendarTapDetails details) {
                  if (details.targetElement == CalendarElement.appointment) {
                    final tappedAppointment = details.appointments!.first;

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddOrUpdateTaskScreen(
                                type: Taskcreationtype.Update,
                                title: tappedAppointment.subject,
                                todoId: tappedAppointment.id,
                                category: tappedAppointment.notes,
                                dueDate: (tappedAppointment.startTime))));
                  }
                },
              );
            }),
      ),
    ));
  }
}

/// Custom data source for the calendar
class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Appointment> source) {
    appointments = source;
  }
}
