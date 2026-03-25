import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eac_patient/screens/forgot/forgot.dart';
import 'package:eac_patient/screens/login/login_screen.dart';
import 'package:eac_patient/screens/main_page_manager.dart';
import 'package:eac_patient/screens/signin/sign_in.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_notification/in_app_notification.dart';

import 'screens/main/main_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDa7cOSfulYwus9qWyLsh2x4VFqzlIxURM",
        authDomain: "asthma-care.firebaseapp.com",
        databaseURL: "https://asthma-care-default-rtdb.asia-southeast1.firebasedatabase.app",
        projectId: "asthma-care",
        storageBucket: "asthma-care.appspot.com",
        messagingSenderId: "73254897805",
        appId: "1:73254897805:web:8f15771ef9d160a2db3ac4",
        measurementId: "G-389PK4ES9G"
    ),
  );
  FirebaseFirestore.instance;
  // await FirebaseAppCheck.instance.activate(
  //   webRecaptchaSiteKey: '6LeEvpQnAAAAANiNyIHpzUhvR0qDIkQQELven5QS',
  // );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return InAppNotification(
      child: MaterialApp(
        title: 'Patient Page',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MainPageManager(),
      ),
    );
  }
}


