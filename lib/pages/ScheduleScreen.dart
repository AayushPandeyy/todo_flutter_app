import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
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
      body: StreamBuilder(
          stream: Firestoreservice().getTasksBasedOnUser(auth.currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            _appointments = snapshot.data!
                .map((snap) => Appointment(
                    startTime: (snap["dueDate"] as Timestamp).toDate(),
                    endTime: (snap["dueDate"] as Timestamp).toDate(),
                    isAllDay: true,
                    subject: snap["task"],
                    color: Colors.green))
                .toList();
            return SfCalendar(
              view: CalendarView.schedule,
              showTodayButton: true,
              initialSelectedDate: _selectedDay,
              dataSource: EventDataSource(_appointments),
            );
          }),
    ));
  }
}

/// Custom data source for the calendar
class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Appointment> source) {
    appointments = source;
  }
}
