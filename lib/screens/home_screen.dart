import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:software_engineering_project/controllers/user_controller.dart';

import 'package:software_engineering_project/models/user_model.dart';
import 'package:software_engineering_project/screens/chat_screen.dart';
import 'package:software_engineering_project/utility/globals.dart' as globals;
import 'package:software_engineering_project/utility/json_help.dart';
import 'package:software_engineering_project/utility/local_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                key: Key("QRButton"),
                icon: Icon(Icons.share),
                onPressed: () => {showQRCode(context)})
          ],
        ),
        body: ChatList(),
        drawer: MenuDrawer(), key: Key("DrawerButton"),);
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
                  key: Key("QRImage"),
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
  Stream<DocumentSnapshot> activeChatListFirebase;
  QuerySnapshot usersCollection;
  Timer refreshTimer;

  void loadCurrentUserData() async {
    await LocalStorage.init();
    globals.currentUser = User(
        LocalStorage.prefs.getString("currentUserName"),
        LocalStorage.prefs.getString("currentUUID"),
        "Time IDK",
        LocalStorage.prefs.getString("RSA_private_key"));
  }

  void getContacts() async {
    var allUsers = await FirebaseFirestore.instance.collection("Users").get();
    setState(() {
      usersCollection = allUsers;
    });
  }

  @override
  void initState() {
    super.initState();
    activeChatListFirebase = FirebaseFirestore.instance
        .collection("Users")
        .doc(globals.currentUser.uuID)
        .collection("messages")
        .doc("activeChats")
        .snapshots();
    getContacts();
    loadCurrentUserData();
    // refreshTimer = Timer.periodic(Duration(seconds: 5), (Timer t) {
    //   setState(() {
    //     print('refreshing screen');
    //   });
    // });
  }

  @override
  void dispose() {
    // refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: activeChatListFirebase,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            return chatListBuilder(snapshot.data);
          } else if (snapshot.hasError) {
            return Center(
                child:
                    Text("No Conversations Yet...\nTry Adding Some Contacts."));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget chatListBuilder(DocumentSnapshot activeChatList) {
    var usersList = usersCollection?.docs?.map((e) => e.data())?.toList();
    activeChats.clear();
    //converting activeChatList to active chat map
    var activeChatUUIDList = activeChatList.data().keys.toList();
    activeChatUUIDList.removeWhere((element) => element == "init");
    usersList?.retainWhere(
        (element) => activeChatUUIDList.contains(element["UUID"]));
    //convert to user list
    usersList?.forEach((element) {
      activeChats.add(User.fromJson(element));
    });

    //activeChats = usersCollection.docs.map((e) => User.fromJson(e.data()));

    return chatListWidget();

    //activeChats = activeChatList.map((data) => User.fromJson(data)).toList();
    //print(activeChats.toString());
  }

  Widget chatListWidget() {
    //if active chat list is empty return info on how to create new chat
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
                                            fontSize:
                                                globals.kDefaultHeaderSize,
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
      key: Key("Drawer"),
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              LocalStorage.prefs.getString("currentUserName"),
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
            key: Key("DeleteAcc"),
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
    // Idk whether to leave this here or toss it straight to onTap function in the widget.
    // TODO: decide
    deleteUser();
    Navigator.of(context).pushReplacementNamed("/register");

    setState(() {
      print("update after set-state");
    });
  }
}
