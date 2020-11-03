import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:software_engineering_project/models/message_model.dart';
import 'package:software_engineering_project/screens/chat_screen.dart';
import 'package:software_engineering_project/data/chats_data.dart';
import 'package:software_engineering_project/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 8,
          title: Text('Inbox'),
        ),
        body: ChatList(),
        drawer: MenuDrawer()
    );
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
          return GestureDetector(
            // Opens chat scree on press
            onTap: () =>
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      // This is where the user data is sent to the chat screen
                      builder: (_) =>
                          ChatScreen(
                            user: chat.sender,
                          ),
                    )),
            child: Container(
              // Sets the padding for all elements in the container
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: Row(
                // A list of contacts goes here I suppose? Or at least how they look :I
                children: <Widget>[
                  Container(
                    // Sets the padding between the user icon and the little ring around it :3
                      padding: EdgeInsets.all(2),
                      // Makes the user icon pretty :3
                      // Checks whether the messages were read, if not, a ring appears around the icon
                      decoration: chat.unread
                          ? BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(40)),
                          // User icon border
                          border: Border.all(
                            width: 2,
                            color: Theme
                                .of(context)
                                .primaryColor,
                          ),
                          // Shape of the icon shadow
                          // shape: BoxShape.circle,
                          // The icon shadow itself
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                            )
                          ])
                          : BoxDecoration(
                        // Shape of the icon shadow
                          shape: BoxShape.circle,
                          // The icon shadow itself
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                            )
                          ]),
                      // The user icon
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(chat.sender.imageUrl),
                      )),
                  // User's name by the icon, time, message preview
                  Container(
                    // This makes the with of the element 65 % of the device-width
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.65,
                      padding: EdgeInsets.only(
                        left: 20,
                      ),
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                  fontSize: 11,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black54,
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
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
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
  _MenuDrawerState(){
    LocalStorage.init();
  }

  var userName = LocalStorage.prefs.getString("currentUserName") ?? "hate this bug";

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
              //todo: implement contact add with qr codes
              Navigator.pop(context);
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

  //this method deletes user info from local storage and firebase Users collection
  void deleteCurrentUser() async {
    //TODO: delete user messages in local storage

    LocalStorage.init();
    var currentUUID = LocalStorage.prefs.getString("currentUUID");

    var users = FirebaseFirestore.instance.collection("Users");
    await users.doc(currentUUID).delete()
        .catchError((error) => print("Failed to add user: $error"));

    LocalStorage.prefs.remove("currentUUID");
    LocalStorage.prefs.remove("currentUserName");
    LocalStorage.prefs.setBool("userRegistered", false);
    Navigator.of(context).pushReplacementNamed("/register");
  }
}


