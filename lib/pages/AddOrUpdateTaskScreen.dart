import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:todo_firebase_app/admob/CustomBannerAd.dart';
import 'package:todo_firebase_app/enums/TaskCreationType.dart';
import 'package:todo_firebase_app/services/FirestoreService.dart';
import 'package:todo_firebase_app/utilities/Categories.dart';
import 'package:todo_firebase_app/utilities/ColorsToUse.dart';
import 'package:todo_firebase_app/widgets/common/CustomButton.dart';
import 'package:todo_firebase_app/widgets/common/CustomTextField.dart';

class AddOrUpdateTaskScreen extends StatefulWidget {
  final String? title;
  final Enum type;
  final String? todoId;
  final String? category;
  final DateTime? dueDate;
  const AddOrUpdateTaskScreen(
      {super.key,
      required this.type,
      this.title,
      this.todoId,
      this.category,
      this.dueDate});

  @override
  State<AddOrUpdateTaskScreen> createState() => _AddOrUpdateTaskScreenState();
}

class _AddOrUpdateTaskScreenState extends State<AddOrUpdateTaskScreen> {
  String? _selectedCategory;
  final _categories = Categories().categoryIcons.keys.toList();
  final taskController = TextEditingController();
  final firestoreService = Firestoreservice();
  final auth = FirebaseAuth.instance;
  DateTime _selectedDay = DateTime.now();
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  final int _maxFailedLoadAttempts = 3; // Maximum load attempts

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId:
          'ca-app-pub-3940256099942544/1033173712', // Replace with your Ad Unit ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          setState(() {
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          setState(() {
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
          });
          if (_numInterstitialLoadAttempts < _maxFailedLoadAttempts) {
            loadInterstitialAd(); // Retry loading the ad
          }
        },
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadInterstitialAd();
    if (widget.dueDate != null) {
      _selectedDay = widget.dueDate!;
    }
    if (widget.category != null) {
      _selectedCategory = widget.category;
    }
  }

  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  void addTodo() async {
    if (_selectedCategory == null || taskController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please fill all the fields")));
      return;
    } else {
      await firestoreService.addTodo(auth.currentUser!.uid, taskController.text,
          _selectedCategory, _selectedDay, FieldValue.serverTimestamp());
      _interstitialAd!.show();
      Navigator.pop(context);
    }
  }

  void updateTodo() async {
    if (_selectedCategory == null || taskController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please fill all the fields")));
      return;
    } else {
      await firestoreService.updateTodoTask(
          widget.todoId!,
          auth.currentUser!.uid,
          taskController.text,
          _selectedCategory,
          _selectedDay);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isAdd = widget.type == Taskcreationtype.Add;

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BannerAdWidget(),
              Text(isAdd ? "Add a new task" : "Update Task",
                  style: const TextStyle(
                      color: Colors.grey,
                      fontFamily: "Gabarito",
                      fontSize: 40,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 10,
              ),
              SfCalendar(
                view: CalendarView.month,
                showTodayButton: true,
                // Set the initial display date to today
                selectionDecoration: BoxDecoration(
                    border: Border.all(color: ColorsToUse().primaryColor)),
                onTap: (CalendarTapDetails details) {
                  setState(() {
                    _selectedDay = details.date!;
                  });
                },
                initialSelectedDate: _selectedDay,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  title: widget.title,
                  placeholder: "New Task",
                  controller: taskController,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Due On : ${DateFormat('d MMMM yyyy').format(_selectedDay)}",
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: "Gabarito",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomDropdown(
                  hintText: "Select a type",
                  initialItem: _selectedCategory,
                  items: _categories,
                  onChanged: (category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  }),
              SizedBox(
                height: 10,
              ),
              CustomButton(
                  text: isAdd ? "Add" : "Update",
                  onPress: () async {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(isAdd ? "Adding Task" : "Updating Task"),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  const CircularProgressIndicator()
                                ],
                              ),
                            ));
                    isAdd ? addTodo() : updateTodo();
                    Navigator.pop(context);
                  })
            ],
          ),
        ),
      ),
    ));
  }
}
