import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:software_engineering_project/models/message_model.dart';
import 'package:software_engineering_project/screens/chat_screen.dart';
import 'package:software_engineering_project/data/chats_data.dart';
import 'package:software_engineering_project/utility/globals.dart';
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
            style: TextStyle(fontSize: kDefaultHeaderSize),
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
                padding: const EdgeInsets.all(kDefaultPadding),
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
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: chats.length,
        // Builds the message and user data from message_model.dart
        itemBuilder: (BuildContext context, int index) {
          // With this we can call the message info
          final Message chat = chats[index];
          return Card(
            elevation: 8,
            child: GestureDetector(
                // Opens chat scree on press
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      // This is where the user data is sent to the chat screen
                      builder: (_) => ChatScreen(
                        user: chat.sender,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    // For user's name
                                    Text(
                                      chat.sender.name,
                                      style: TextStyle(
                                          fontSize: kDefaultHeaderSize,
                                          fontWeight: FontWeight.bold,
                                          decoration: chat.unread
                                              ? TextDecoration.underline
                                              : null),
                                    ),
                                    // Container for the little grin dot beside the username
                                    // If the user is online
                                    chat.sender.isOnline
                                        ? Container(
                                            margin:
                                                const EdgeInsets.only(left: 5),
                                            width: 7,
                                            height: 7,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.green,
                                            ),
                                          )
                                        :
                                        // If user if offline, the container is null
                                        Container(
                                            child: null,
                                          )
                                  ],
                                ),
                                // For timestamp
                                Text(
                                  chat.time,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    color: kAccentBlack,
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
                                chat.text,
                                style: TextStyle(
                                  color: kAccentBlack,
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

// drawer stuff
class MenuDrawer extends StatefulWidget {
  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  _MenuDrawerState() {
    LocalStorage.init();
  }

  var userName =
      LocalStorage.prefs.getString("currentUserName") ?? "hate this bug";

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(userName),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text("Contacts"),
            leading: Icon(Icons.contacts_outlined),
            onTap: () {
              //todo: user screen to create new convo
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("Add Contact"),
            leading: Icon(Icons.add_circle_outline),
            onTap: () {
              Navigator.pushNamed(context, "/qr_scan")
                  .then((value) => addUserToContacts(value));
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
  void addUserToContacts(String uuID) async{

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

    //todo: add data to json and maje contact list to read from json

  }

  //this method deletes user info from local storage and firebase Users collection
  void deleteCurrentUser() async {
    //TODO: delete user messages in local storage

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
