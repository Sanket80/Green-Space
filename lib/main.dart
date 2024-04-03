import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:greenspace/Screens/ManagerDashboard.dart';
import 'package:greenspace/Screens/Tasks.dart';
import 'package:greenspace/Screens/onBoarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String storageBucketUrl = 'gs://garden-management-7c59e.appspot.com';
  Platform.isAndroid
      ? await Firebase.initializeApp(
    options:FirebaseOptions(
      apiKey: 'AIzaSyDyo2hUyYdb1EjYg2AlJ-L5FsFPbxsdYvU',
      appId: '1:144812210558:android:8c312af49a8f79a6a4db2f',
      messagingSenderId: '144812210558',
      projectId: 'garden-management-7c59e',
      storageBucket: storageBucketUrl,
    ),)
      : await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: ManagerDashboard(),
    );
  }
}

