import 'package:flutter/material.dart';
import 'package:software_engineering_project/screens/contact_screen.dart';
import 'package:software_engineering_project/screens/register_screen.dart';
import './utility/qr_scanner.dart';
import './screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:software_engineering_project/utility/local_storage.dart';

void main() async {
  //doing some firebase stuff im yet to understand
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    title: 'Drugz No Sell Plz',
    debugShowCheckedModeBanner: false,
    home: await home(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    routes: <String, WidgetBuilder>{
      "/home": (BuildContext context) => HomeScreen(),
      "/register": (BuildContext context) => RegisterScreen(),
      "/qr_scan" : (BuildContext context) => QRScanner(),
      "/contact_list": (BuildContext context) => ContactScreen()
    },
  ));
}

//method that controls what apps home will be
Future<Widget> home() async {
  //setting default home of material app to be register screen
  Widget defaultHome = RegisterScreen(); //HomeScreen();  //
  //changing it if user is already registered
  bool test = await currentUserExists();
  if (test) {
    defaultHome = HomeScreen();
  }
  return defaultHome;
}

Future<bool> currentUserExists() async {
  bool userReg;
  await LocalStorage.init();
  print(LocalStorage.prefs.toString());
  userReg = LocalStorage.prefs.getBool("userRegistered") ?? false;
  print(userReg);
  return userReg;
}
