import 'package:shared_preferences/shared_preferences.dart';

// class used to access shared preferences
class LocalStorage {
  static SharedPreferences prefs;

  static Future init() async {
    prefs = await SharedPreferences.getInstance();
  }
}