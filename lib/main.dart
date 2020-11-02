import 'package:flutter/material.dart';
import 'package:software_engineering_project/screens/register_screen.dart';

import './screens/home_screen.dart';
import './screens/test_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:software_engineering_project/globals.dart';

SharedPreferences prefs;

void main() async {
  //doing some firebase stuff im yet to understand
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocalStorage.init();

  //setting default home of material app to be register screen
  Widget defaultHome = RegisterScreen();
  //changing it if user is already registered
  if (currentUserExists()) {
    defaultHome = HomeScreen();
  }

  runApp(new MaterialApp(
    title: 'Drugz No Sell Plz',
    debugShowCheckedModeBanner: false,
    home: defaultHome,
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    routes: <String, WidgetBuilder>{
      "/home": (BuildContext context) => HomeScreen(),
      "/register": (BuildContext context) => RegisterScreen(),
    },
  ));
}

bool currentUserExists() {
  try{
    if(LocalStorage.prefs.getBool("userRegistered")){
      return true;
    }
  }catch(error){
    print(error);
    return false;
  }
}