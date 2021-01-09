import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:software_engineering_project/utility/file_sys_help.dart';
import 'package:software_engineering_project/utility/json_help.dart';
import 'package:software_engineering_project/utility/globals.dart' as globals;

void createNewChat(dynamic contactData) async {
  _createLocalNewChat(contactData);
  _createFirebaseNewChat(contactData);
}

void _createLocalNewChat(dynamic contactData) async {
  var fileSysHelp = FileSystemHelper();
  var jsonHelp = JsonHelper();
  var contactChatDirPath = await fileSysHelp.getDirPath(globals.kChatDir) +
      contactData["UUID"] +
      '/';
  var contactChatDir = Directory(contactChatDirPath);

  //creating directory to save new chats, deleting it if it already exists
  if (contactChatDir.existsSync()) {
    await contactChatDir.delete(recursive: true);
  }
  await contactChatDir.create(recursive: true);
  await jsonHelp.createJsonFile(
      globals.kChatDir + contactData["UUID"] + "/messages.json");

  //adding user info to active chats json file
  var activeChatsJson =
  File(await fileSysHelp.getFilePath(globals.kActiveChatsJson));

  //creating file if it doesn't exist
  if (!activeChatsJson.existsSync()) {
    await jsonHelp.createJsonFile(globals.kActiveChatsJson);
  }

  // getting active chats info to list
  var activeChatsList = await jsonHelp.getJsonArray(globals.kActiveChatsJson);

  //if active chat list already contains contact data remove it
  activeChatsList
      .retainWhere((element) => element["UUID"] != contactData["UUID"]);
  activeChatsList.add(contactData);

  //saving list to json and writing it to file
  var updatedActiveChatsJsonString =
  jsonHelp.returnJsonString(activeChatsList);
  print(updatedActiveChatsJsonString);
  jsonHelp.writeJsonStringToFile(
      globals.kActiveChatsJson, updatedActiveChatsJsonString);
}

void _createFirebaseNewChat(dynamic contactData){
  //adding chat info in firestore
  FirebaseFirestore.instance
      .collection("Users")
      .doc(globals.currentUser.uuID)
      .collection("messages")
      .doc("activeChats")
      .set({contactData["UUID"]: contactData["UUID"]},
      SetOptions(merge: true));
  FirebaseFirestore.instance
      .collection("Users")
      .doc(contactData["UUID"])
      .collection("messages")
      .doc("activeChats")
      .set({globals.currentUser.uuID: globals.currentUser.uuID},
      SetOptions(merge: true));
}