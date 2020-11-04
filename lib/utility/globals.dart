import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class used to access shared preferences
class LocalStorage {
  static SharedPreferences prefs;

  static Future init() async {
    prefs = await SharedPreferences.getInstance();
  }
}

// constants
const double kDefaultPadding = 16.0;
const double kDefaultHeaderSize = 22.0;

const Color kThemeColor = Colors.blue;
const Color kAccentColor = Colors.blueAccent;
const Color kAccentBlack = Colors.black54;
