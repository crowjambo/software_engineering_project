import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:software_engineering_project/models/user_model.dart';
import 'package:software_engineering_project/screens/chat_screen.dart';
import 'package:software_engineering_project/utility/file_sys_help.dart';
import 'package:software_engineering_project/utility/globals.dart' as globals;
import 'package:software_engineering_project/utility/json_help.dart';
import 'package:software_engineering_project/utility/local_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 8,
          title: Text(
            'Inbox',
            style: TextStyle(fontSize: globals.kDefaultHeaderSize),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.share), onPressed: () => {showQRCode(context)})
          ],
        ),
        body: ChatList(),
        drawer: MenuDrawer());
  }

  Future showQRCode(BuildContext context) {
    LocalStorage.init();
    var currentUUID = LocalStorage.prefs.getString("currentUUID");

    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
                padding: const EdgeInsets.all(globals.kDefaultPadding),
                child: QrImage(
                  data: currentUUID,
                  version: QrVersions.auto,
                  size: 320,
                  gapless: true,
                  errorStateBuilder: (cxt, err) {
                    return Container(
                      child: Center(
                        child: Text(
                          "Uh oh! Something went wrong...",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                )),
          );
        });
  }
}

// chat list stuff
class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<User> activeChats = List<User>();
  var jsonHelp = JsonHelper();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: jsonHelp.getJsonArray(globals.kActiveChatsJson),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            return chatListWidget(snapshot.data);
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    "No Conversations Yet...\n Try Adding Some Contacts."));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget chatListWidget(List<dynamic> activeChatList) {
    //converting activeChatList to active chat map
    activeChats = activeChatList.map((data) => User.fromJson(data)).toList();
    print(activeChats.toString());
    //if active chat list is empty return info on how to create new chat
    //todo: refine this
    if (activeChats.isEmpty) {
      return Center(
        child: Text(
          "No Active Conversations... ",
          textAlign: TextAlign.center,
        ),
      );
    } else {
      //if its not empty return this
      return ListView.builder(
          itemCount: activeChats.length,
          // Builds the message and user data from message_model.dart
          itemBuilder: (BuildContext context, int index) {
            // With this we can call the message info
            //final Message chat = chats[index];
            return Card(
              elevation: 8,
              child: InkWell(
                  // Opens chat scree on press
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        // This is where the user data is sent to the chat screen
                        builder: (_) => ChatScreen(
                          senderData: activeChats[index],
                        ),
                      )),
                  child: Container(
                      // Sets the padding for all elements in the container
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      child: Container(
                          // This makes the with of the element 65 % of the device-width
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: Column(
                            children: <Widget>[
                              Row(
                                // Assigns the content spacing
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      // For user's name
                                      Text(
                                        activeChats[index].userName,
                                        style: TextStyle(
                                            fontSize: globals.kDefaultHeaderSize,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  // For timestamp
                                  Text(
                                    activeChats[index].lastMessage,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      color: globals.kAccentBlack,
                                    ),
                                  )
                                ],
                              ),
                              // SizedBox to make a gap between the two containers
                              SizedBox(height: 10),
                              // For the preview message
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  activeChats[index].lastMessage,
                                  style: TextStyle(
                                    color: globals.kAccentBlack,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          )))),
            );
          });
    }
  }
}

// drawer stuff
class MenuDrawer extends StatefulWidget {
  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              globals.userName,
              style: TextStyle(fontSize: globals.kDefaultHeaderSize * 1.5),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text("Contacts"),
            leading: Icon(Icons.contacts_outlined),
            onTap: () {
              //todo: user screen to create new convo
              Navigator.pushNamed(context, "/contact_list");
              //Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Add Contact"),
            leading: Icon(Icons.add_circle_outline),
            onTap: () {
              Navigator.pushNamed(context, "/qr_scan").then((value) {
                if (value != null) {
                  addUserToContacts(value);
                }
              });
              //Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Delete Your Account"),
            leading: Icon(Icons.delete_forever),
            onTap: () {
              deleteCurrentUser();
            },
          ),
        ],
      ),
    );
  }

  //this method adds new contact to contacts json using its UUID
  void addUserToContacts(String uuID) async {
    //gets user data from firestore
    var users = FirebaseFirestore.instance.collection("Users");
    var newUserData = await users.doc(uuID).get();
    var newUserDataMap = newUserData.data();

    //shows dialog "added user: USERNAME"
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('User added to Contact List'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Username: ${newUserDataMap["username"]}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    var jsonHelp = JsonHelper();
    await jsonHelp.createJsonFile(globals.kContactListJson);
    var contactList = await jsonHelp.getJsonArray(globals.kContactListJson);
    // checking if contact list already contains new contact info
    if (!contactList.contains(newUserDataMap)) {
      //adding info and saving it to json
      contactList.add(newUserDataMap);
      var newJsonString = jsonHelp.returnJsonString(contactList);
      print(newJsonString.toString());
      jsonHelp.writeJsonStringToFile(globals.kContactListJson, newJsonString);
    }
  }

  //this method deletes user info from local storage and firebase Users collection
  void deleteCurrentUser() async {
    //deleting everything from local storage
    var fileSysHelp = FileSystemHelper();
    var chatDir = Directory(await fileSysHelp.getDirPath(globals.kChatDir));
    var contactFile = File(await fileSysHelp.getFilePath(globals.kContactListJson));
    if (chatDir.existsSync()) {
      await chatDir.delete(recursive: true);
    }
    if (contactFile.existsSync()) {
      await contactFile.delete(recursive: true);
    }

    //deleting user from firestore
    LocalStorage.init();
    var currentUUID = LocalStorage.prefs.getString("currentUUID");

    var users = FirebaseFirestore.instance.collection("Users");
    await users
        .doc(currentUUID)
        .delete()
        .catchError((error) => print("Failed to delete user: $error"));

    LocalStorage.prefs.remove("currentUUID");
    LocalStorage.prefs.remove("currentUserName");
    LocalStorage.prefs.setBool("userRegistered", false);
    Navigator.of(context).pushReplacementNamed("/register");
  }
}
