import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:software_engineering_project/controllers/user_controller.dart';
import 'package:software_engineering_project/utility/globals.dart' as globals;

import 'currentUserExists_test.dart';

void main() {
  group("Create user", () {
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
  });

  group("Delete user", (){
    test('When user is deleted Then it is removed from local storage', () async {
      SharedPreferences.setMockInitialValues(<String, dynamic>{
        "currentUserName": testUser.userName,
        "currentUUID": testUser.uuID,
        "RSA_private_key": "privateKey123",
        "RSA_public_key": "publicKey123",
        "userRegistered": true
      });

      // Check for the user to be in the local storage
      var userCreated = await currentUserExists();
      expect(userCreated, true);

      // Removal
      await deleteUserInLocalStorage();

      // Checks if user was deleted
      SharedPreferences prefs = await SharedPreferences.getInstance();
      expect(prefs.getString("currentUUID"), null);
      expect(prefs.getString("currentUserName"), null);
      expect(prefs.getString("RSA_private_key"), null);
      expect(prefs.getBool("userRegistered"), false);
    });

    test('When user is not deleted Then it stays in local storage', () async {
      SharedPreferences.setMockInitialValues(<String, dynamic>{
        "currentUserName": testUser.userName,
        "currentUUID": testUser.uuID,
        "RSA_private_key": "privateKey123",
        "RSA_public_key": "publicKey123",
        "userRegistered": true
      });

      // Check for the user to be in the local storage
      var userCreated = await currentUserExists();
      expect(userCreated, true);

      // Doesn't remove on time
      deleteUserInLocalStorage();

      // Checks if user was not deleted
      SharedPreferences prefs = await SharedPreferences.getInstance();
      expect(prefs.getString("currentUUID"), testUser.uuID);
      expect(prefs.getString("currentUserName"), testUser.userName);
      expect(prefs.getString("RSA_private_key"), testUser.RSA_private_key);
      expect(prefs.getBool("userRegistered"), true);
    });
  });

  group("current user exists tests", () {
    test('When user exists Then currentUserExists return true', () async {
      SharedPreferences.setMockInitialValues(
          <String, dynamic>{"userRegistered": true});

      var result = await currentUserExists();
      expect(result, true);
    });

    test('When user does not exist Then currentUserExists return false',
        () async {
      SharedPreferences.setMockInitialValues(
          <String, dynamic>{"userRegistered": false});

      var result = await currentUserExists();
      expect(result, false);
    });

    test('When user is registered Then userName is stored globally', () async {
      SharedPreferences.setMockInitialValues(<String, dynamic>{
        "currentUserName": testUser.userName,
        "currentUUID": testUser.uuID,
      });

      await currentUserExists();

      var result = globals.currentUser.userName;
      expect(result, testUser.userName);
    });

    test('When user is registered Then uuid is stored globally', () async {
      SharedPreferences.setMockInitialValues(<String, dynamic>{
        "currentUserName": testUser.userName,
        "currentUUID": testUser.uuID,
      });

      await currentUserExists();

      var result = globals.currentUser.uuID;
      expect(result, testUser.uuID);
    });
  });
}
