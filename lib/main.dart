import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:todo_firebase_app/firebase_options.dart';
import 'package:todo_firebase_app/pages/LoginChecker.dart';

void main() async {
  final devices = ["D0CAC40D4C6FACD5E21BF5AF3B84763E"];
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  MobileAds.instance.initialize();
  RequestConfiguration configuration =
     RequestConfiguration(testDeviceIds: devices);
     MobileAds.instance.updateRequestConfiguration(configuration);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskopia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginChecker(),
      debugShowCheckedModeBanner: false,
    );
  }
}
