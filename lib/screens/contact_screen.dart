import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:software_engineering_project/utility/globals.dart' as globals;
import 'package:software_engineering_project/utility/json_help.dart';
import 'package:software_engineering_project/utility/file_sys_help.dart';

class ContactScreen extends StatefulWidget {
  ContactScreen({Key key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  var jsonHelp = JsonHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Contact List"),
        ),
        body: FutureBuilder<List<dynamic>>(
          future: jsonHelp.getJsonArray(globals.kContactListJson),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              return buildContactList(snapshot.data);
            } else if (snapshot.hasError) {
              print("error at contacts list future");
              return Center(child: Text("No Contacts Yet..."));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Widget buildContactList(List<dynamic> contactData) {
    return ListView.builder(
        padding: EdgeInsets.all(globals.kDefaultPadding),
        itemCount: contactData.length,
        itemBuilder: (context, i) {
          return Card(
            elevation: 4,
            child: ListTile(
              title: Text(
                contactData[i]["username"],
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: globals.kDefaultHeaderSize),
              ),
              onTap: () {
                createNewChat(contactData[i]);
                Navigator.pushReplacementNamed(context, "/home");
                //Navigator.popUntil(context, ModalRoute.withName("/home"));
              },
            ),
          );
        });
  }

  void createNewChat(dynamic contactData) async {
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

    //adding chat info in firestore
    var activeChatListFirebaseSender = FirebaseFirestore.instance
        .collection("Users")
        .doc(globals.currentUser.uuID)
        .collection("messages")
        .doc("activeChats")
        .set({contactData["UUID"]: contactData["UUID"]},
            SetOptions(merge: true));
    var activeChatListFirebaseReceiver = FirebaseFirestore.instance
        .collection("Users")
        .doc(contactData["UUID"])
        .collection("messages")
        .doc("activeChats")
        .set({globals.currentUser.uuID: globals.currentUser.uuID},
            SetOptions(merge: true));
  }
}
