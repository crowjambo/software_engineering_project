import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:software_engineering_project/controllers/user_controller.dart';
import 'package:software_engineering_project/utility/globals.dart' as globals;

void main() {
  test('When user is created Then it is added to local storage', () async {
    // This is needed for the test to work. Otherwise async gap happens
    SharedPreferences.setMockInitialValues(<String, dynamic>{
      "currentUserName": "testUsername",
      "userRegistered": true
    });

    // Check for the user to be in the local storage
    var userCreated = await currentUserExists();
    expect(userCreated, true);

    // print(globals.currentUser.userName);

    // Use the add user function
    createUserInLocalStorage("anotherTestUser");

    // Check for the user to be in the local storage
    var anotherUserCreated = await currentUserExists();
    expect(anotherUserCreated, true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    expect(prefs.getString("currentUserName"), "anotherTestUser");
  });
}