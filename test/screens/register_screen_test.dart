import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:software_engineering_project/screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:software_engineering_project/main.dart' as appMain;

void main() {
  group("Register Screen Tests", () {
    testWidgets("When create new identity button is pressed Then stores username in local storage", (WidgetTester tester) async {
      final userNameField = find.byKey(ValueKey("userNameInput"));
      final createButton = find.byKey(ValueKey("createNewIdentity"));
      final testUsername = "testUsername123";

      appMain.main();
      
      await tester.pumpWidget(MaterialApp(home: RegisterScreen()));
      await tester.enterText(userNameField, testUsername);
      await tester.tap(createButton);
      await tester.pump(); // Rebuilds the widget

      var prefs = await SharedPreferences.getInstance();

      expect(prefs.getString("currentUser"), testUsername);
    });


  });
}