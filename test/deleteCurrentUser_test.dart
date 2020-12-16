import 'package:test/test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:software_engineering_project/main.dart';
import 'package:software_engineering_project/models/user_model.dart';
import 'package:software_engineering_project/screens/home_screen.dart';

var mockUser = User("testUsername", "123", "00:00");

void main() {
  group('LocalStorage User Removal', () {
    
    test('When user is deleted Then it is removed from local storage', () async {
      SharedPreferences.setMockInitialValues(<String, dynamic>{
        "currentUserName": mockUser.userName,
        "currentUUID": mockUser.uuID,
        "userRegistered": true
      });

      // For the user to be in the local storage
      var userCreated = await currentUserExists();
      expect(userCreated, true);

      // Removal

      // The deleteCurrentUser should be refactored so the tests could be written for firebase(optionally) and local storage

      // deleteCurrentUserFromLocalStorage();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      expect(prefs.getString("currentUserName"), null);
    });
  });
}