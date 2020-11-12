import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:software_engineering_project/utility/globals.dart';
import 'package:software_engineering_project/utility/local_storage.dart';
import 'package:uuid/uuid.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var userNameTextController =
      TextEditingController(text: "testUsername"); //TODO: remove test username

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create New Identity",
              style: TextStyle(
                  fontSize: kDefaultHeaderSize, fontWeight: FontWeight.bold)),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(kDefaultPadding),
              child: TextField(
                controller: userNameTextController,
                decoration: InputDecoration(hintText: "UserName"),
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: kDefaultHeaderSize),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(kDefaultPadding),
              child: RaisedButton(
                  color: kAccentColor,
                  child: Text("Create New Identity"),
                  onPressed: () {
                    if (userNameTextController.text.isEmpty) {
                      _showNoUserNameAlert();
                    } else {
                      _createUser(userNameTextController.text);
                      //go to home screen
                      Navigator.of(context).pushReplacementNamed('/home');
                    }
                  }),
            )
          ],
        ));
  }

  void _createUser(String userName) async {
    //TODO: add crypto key and userAddID and post that s to firebase
    var users = FirebaseFirestore.instance.collection("Users");

    //generating new UUID
    var uuidGen = Uuid();
    var uuid = uuidGen.v4();

    //sending username and UUID to firebase storage
    users
        .doc(uuid)
        .set({
          "username": userName,
          "UUID": uuid,
          "addedTime" : DateTime.now().toString()
        })
        .then((value) => print("user added uuid: " + uuid))
        .catchError((error) => print("Failed to add user: $error"));
    //saving username andUUID to local storage
    await LocalStorage.init();
    LocalStorage.prefs.setString("currentUUID", uuid);
    LocalStorage.prefs.setString("currentUserName", userName);
    LocalStorage.prefs.setBool("userRegistered", true);
  }

  void _showNoUserNameAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('User Name is required'),
          actions: <Widget>[
            TextButton(
              child: Text('Okay.'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
