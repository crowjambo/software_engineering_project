import 'package:test/test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:software_engineering_project/models/user_model.dart';
import 'package:software_engineering_project/controllers/user_controller.dart';


var mockUser = User("testUsername", "123", "00:00", "privateKey");

void main() {
  group('LocalStorage User Creation', () {

    test('When user is created Then it is added to local storage', () async {
      // SharedPreferences.setMockInitialValues(<String, dynamic>{
      //   "currentUserName": mockUser.userName,
      //   "currentUUID": mockUser.uuID,
      //   "RSA_private_key": "privateKey123",
      //   "RSA_public_key": "publicKey123",
      //   "userRegistered": true
      // });

      // Create user
      createUserInLocalStorage(mockUser.userName);

      // Check if user is created
      SharedPreferences prefs = await SharedPreferences.getInstance();
      expect(prefs.getString("currentUserName"), mockUser.userName);
      expect(prefs.getBool("userRegistered"), true);

      // Check for the user to be in the local storage
      var userCreated = await currentUserExists();
      expect(userCreated, true);

      // Removal
      await deleteUserInLocalStorage();

      // Checks if user was deleted
      expect(prefs.getString("currentUUID"), null);
      expect(prefs.getString("currentUserName"), null);
      expect(prefs.getString("RSA_private_key"), null);
      expect(prefs.getBool("userRegistered"), false);

    });

  });
}