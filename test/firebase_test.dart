import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:software_engineering_project/controllers/user_controller.dart';
import 'package:software_engineering_project/utility/globals.dart' as globals;

void main() {
  group("Database Tests", () {
    var userName, uuid;
    var mockFirebase, userCollection;

    setUp(() {
      mockFirebase = MockFirestoreInstance();
      userCollection = "Users";

      userName = "testUsername";
      uuid = "123uuid";

      SharedPreferences.setMockInitialValues(<String, dynamic>{
        "currentUserName": userName,
        "currentUUID": uuid,
        "RSA_private_key": "privateKey123",
        "RSA_public_key": "publicKey123",
        "userRegistered": true
      });

      mockFirebase.collection(userCollection).doc("anotheruuid").set({
        "username": "a name",
        "UUID": "anotheruuid",
        "addedTime": DateTime.now().toString(),
        "RSA_public_key": "lmaososecretkey",
      });
    });

    test("Check whether user is added to the database returns true", () async {
      await createUserInFirebase(mockFirebase);

      var user =
          await mockFirebase.collection(userCollection).doc(uuid).get();

      var hasUser = user.data().containsValue(userName);
      expect(hasUser, true);
    });

    test("Check whether user is removed from the database returns false",
        () async {
      await createUserInFirebase(mockFirebase);
      await currentUserExists();

      await deleteUserInFirebase(mockFirebase);

      var user =
          await mockFirebase.collection(userCollection).doc(uuid).get();

      expect(user.data(), null);
    });
  });
}
