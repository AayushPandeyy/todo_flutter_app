import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Your Schedule",
            style: TextStyle(
                fontSize: 40, fontFamily: "Debug", color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
            stream:
                Firestoreservice().getTasksBasedOnUser(auth.currentUser!.uid),
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
                allowAppointmentResize: true,
                view: CalendarView.schedule,
                showTodayButton: true,
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
