import 'package:test/test.dart';
import 'package:software_engineering_project/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:software_engineering_project/utility/globals.dart' as globals;
import 'package:software_engineering_project/controllers/user_controller.dart';

var testUser = User("testUsername", "123", "00:00", "privateKey");

void main() {
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
}
