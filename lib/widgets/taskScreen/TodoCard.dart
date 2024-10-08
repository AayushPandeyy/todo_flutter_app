import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:todo_firebase_app/services/FirestoreService.dart';

class TodoCard extends StatefulWidget {
  final bool status;
  final String todoId;
  final String task;
  final Timestamp? dueDate;
  const TodoCard(
      {super.key,
      required this.task,
      required this.todoId,
      required this.status,
      this.dueDate});

  @override
  State<TodoCard> createState() => _TodoCardState();
}

InterstitialAd? _interstitialAd;
int _numInterstitialLoadAttempts = 0;

const int _maxFailedLoadAttempts = 3;

class _TodoCardState extends State<TodoCard> {
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId:
          'ca-app-pub-3804780729029008/1314306115', // Replace with your Ad Unit ID
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

  final firestoreService = Firestoreservice();
  final auth = FirebaseAuth.instance;
  bool completed = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 70,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: DateTime.now().difference(widget.dueDate!.toDate()) <
                  const Duration(days: 1)
              ? Colors.white
              : const Color(0xffFF0000)),
      child: Row(
        children: [
          Checkbox(
            value: widget.status,
            onChanged: (value) async {
              setState(() {
                completed = value!;
              });
              await firestoreService.changeCompletedStatus(
                  completed, widget.todoId, auth.currentUser!.uid);
              _interstitialAd!.show();
            },
            checkColor: Colors.white,
            activeColor: Colors.black,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.task,
                  style: TextStyle(
                    decoration: widget.status
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    fontFamily: "Gabarito",
                    fontSize: 25,
                  ),
                ),
                widget.dueDate != null
                    ? Text(
                        "Due Date : ${DateFormat('d MMMM yyyy').format(widget.dueDate!.toDate())}",
                        style: TextStyle(
                          decoration: widget.status
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          fontFamily: "Gabarito",
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      )
                    : Container(),
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.event_repeat,
                        size: 15,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.circle,
                        size: 15,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
