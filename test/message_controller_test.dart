import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:software_engineering_project/controllers/message_controller.dart' as messageCont;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:software_engineering_project/controllers/message_controller.dart';
import 'package:software_engineering_project/utility/globals.dart' as globals;
import 'package:software_engineering_project/models/user_model.dart';

import 'currentUserExists_test.dart';

void main() {
  group("Message sending tests", () {
    var receivedMessageCol, sentMessageCol;
    CollectionReference sentCol, receivedCol;
    MockFirestoreInstance mockFirebase;

    setUp(() {
      // Initialize mock db
      mockFirebase = MockFirestoreInstance();
      receivedMessageCol = "receivedMessages";
      sentMessageCol = "sentMessages";

      //init fake sender User;
      globals.currentUser = User("testUserName", "testUUID", DateTime.now().toString(), "publicKeyString");

      var keyPar = CryptoUtils.generateRSAKeyPair();
      var publicKeyString =
      CryptoUtils.encodeRSAPublicKeyToPem(keyPar.publicKey);
      var privateKeyString =
      CryptoUtils.encodeRSAPrivateKeyToPem(keyPar.privateKey);
      globals.currentUser.RSA_private_key = privateKeyString;
      globals.currentUser.RSA_public_key = publicKeyString;

      // Set mockFirebase structure
      receivedCol = mockFirebase.collection(receivedMessageCol);
      sentCol = mockFirebase.collection(sentMessageCol);
    });

    test("check to see if unencrypted message is sent to FB", () async {

      //init fake receiver User
      User testUser = User("testUserName", "testUUID", DateTime.now().toString(), "TestPrivateKey");
      var keyPar2 = CryptoUtils.generateRSAKeyPair();
      var publicKeyString2 =
      CryptoUtils.encodeRSAPublicKeyToPem(keyPar2.publicKey);
      var privateKeyString2 =
      CryptoUtils.encodeRSAPrivateKeyToPem(keyPar2.privateKey);

      testUser.RSA_private_key = privateKeyString2;
      testUser.RSA_public_key = publicKeyString2;

      var textToSend = "TestTextToSend";
      messageCont.sendMessage(textToSend, testUser, sentCol, receivedCol);

      //checking if received
      var messageCount = await mockFirebase.collection(receivedMessageCol).get();
      expect(messageCount.docs.length, 1);
    });

    test("check to see if encrypted message is sent to FB", () async {

      //init fake receiver User
      User testUser = User("testUserName", "testUUID", DateTime.now().toString(), "TestPrivateKey");
      var keyPar2 = CryptoUtils.generateRSAKeyPair();
      var publicKeyString2 =
      CryptoUtils.encodeRSAPublicKeyToPem(keyPar2.publicKey);
      var privateKeyString2 =
      CryptoUtils.encodeRSAPrivateKeyToPem(keyPar2.privateKey);

      testUser.RSA_private_key = privateKeyString2;
      testUser.RSA_public_key = publicKeyString2;

      var textToSend = "TestTextToSend";
      messageCont.sendMessage(textToSend, testUser, sentCol, receivedCol);

      //checking if received
      var messageCount = await mockFirebase.collection(sentMessageCol).get();
      expect(messageCount.docs.length, 1);
    });

  });
}
