import 'package:test/test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:software_engineering_project/models/user_model.dart';
import 'package:software_engineering_project/controllers/user_controller.dart';

var testUser = User("testUsername", "123", "00:00", "privateKey123");

void main() {
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
}
