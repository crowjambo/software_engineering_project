import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:software_engineering_project/models/user_model.dart';
import 'package:software_engineering_project/utility/file_sys_help.dart';
import 'package:software_engineering_project/utility/local_storage.dart';
import 'package:software_engineering_project/utility/globals.dart' as globals;
import 'package:uuid/uuid.dart';

void createUser(var userName, var firebase) {
  createUserInLocalStorage(userName);
  createUserInFirebase(firebase);
}

void createUserInLocalStorage(var userName) async {
  //generating new UUID
  var uuidGen = Uuid();
  var uuid = uuidGen.v4();

  //Generating RSA KEYS
  var keyPar = CryptoUtils.generateRSAKeyPair();
  var privateKeyString =
  CryptoUtils.encodeRSAPrivateKeyToPem(keyPar.privateKey);
  var publicKeyString = CryptoUtils.encodeRSAPublicKeyToPem(keyPar.publicKey);

  //saving username andUUID to local storage
  await LocalStorage.init();
  LocalStorage.prefs.setString("currentUUID", uuid);
  LocalStorage.prefs.setString("currentUserName", userName);
  LocalStorage.prefs.setString("RSA_private_key", privateKeyString);
  LocalStorage.prefs.setString("RSA_public_key", publicKeyString);
  LocalStorage.prefs.setBool("userRegistered", true);
}

void createUserInFirebase(var firebaseInstance) async {
  var users = firebaseInstance.collection("Users");
  await LocalStorage.init();

  var uuid = LocalStorage.prefs.getString("currentUUID");
  var userName = LocalStorage.prefs.getString("currentUserName");
  var publicKeyString = LocalStorage.prefs.getString("RSA_public_key");

  //sending username and UUID to firebase storage
  users
      .doc(uuid)
      .set({
    "username": userName,
    "UUID": uuid,
    "addedTime": DateTime.now().toString(),
    "RSA_public_key": publicKeyString,
  })
      .then((value) => print("user added uuid: " + uuid))
      .catchError((error) => print("Failed to add user: $error"));
  //creating message collection
  users.doc(uuid).collection("messages").doc("activeChats").set({
    'init': "init",
  });
}

void deleteUser(var firebaseInstance) {
  deleteUserInLocalStorage();
  deleteUserInFirebase(firebaseInstance);
}

void deleteUserInLocalStorage() async {
  await LocalStorage.init();

  //deleting everything from local storage
  var fileSysHelp = FileSystemHelper();
  var chatDir = Directory(await fileSysHelp.getDirPath(globals.kChatDir));
  var contactFile =
  File(await fileSysHelp.getFilePath(globals.kContactListJson));
  if (chatDir.existsSync()) {
    await chatDir.delete(recursive: true);
  }
  if (contactFile.existsSync()) {
    await contactFile.delete(recursive: true);
  }

  LocalStorage.prefs.remove("currentUUID");
  LocalStorage.prefs.remove("currentUserName");
  LocalStorage.prefs.remove("RSA_private_key");
  LocalStorage.prefs.setBool("userRegistered", false);
}

void deleteUserInFirebase(var firebaseInstance) async {
  var currentUUID = globals.currentUser.uuID;

  var users = firebaseInstance.collection("Users");
  await users
      .doc(currentUUID)
      .delete()
      .catchError((error) => print("Failed to delete user: $error"));
}

Future<bool> currentUserExists() async {
  bool userReg;
  await LocalStorage.init();
  // print(LocalStorage.prefs.toString());
  userReg = LocalStorage.prefs.getBool("userRegistered") ?? false;
  globals.currentUser = User(
      LocalStorage.prefs.getString("currentUserName"),
      LocalStorage.prefs.getString("currentUUID"),
      "Time IDK",
      LocalStorage.prefs.getString("RSA_private_key"));
  return userReg;
}