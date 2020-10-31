import 'package:flutter/material.dart';

import './screens/home_screen.dart';
import './screens/test_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;

void main() async {
  //doing some firebase stuff im yet to understand
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //checking for active users (hack? for first time launch)
  setLaunchPrefs();

  runApp(MyApp());
}

void setLaunchPrefs() async {
  // obtain shared preferences
  prefs = await SharedPreferences.getInstance();

  if (prefs.getBool("HasLoggedInUser") == null || prefs.getBool("HasLoggedInUser") == false){
    //select user
  }
  
   print(prefs.getBool("HasLoggedInUser").toString());

  // // set value
  // if (prefs.getBool("IsFirstAppLaunch")) {
  //   // generate UUID + save it
  //   prefs.setBool('isFirstAppLaunch', true);
  // }
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drugz No Sell Plz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RegisterScreen(),
    );
  }
}
