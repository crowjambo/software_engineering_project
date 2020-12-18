import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:software_engineering_project/controllers/user_controller.dart';
import 'package:software_engineering_project/utility/globals.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var userNameTextController =
      TextEditingController(text: "testUsername"); //TODO: remove test username

  var firebaseInstance = FirebaseFirestore.instance;

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
                key: Key("userNameInput"),
                controller: userNameTextController,
                decoration: InputDecoration(hintText: "UserName"),
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: kDefaultHeaderSize),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(kDefaultPadding),
              child: RaisedButton(
                key: Key("createNewIdentity"),
                  color: kAccentColor,
                  child: Text("Create New Identity"),
                  onPressed: () {
                    if (userNameTextController.text.isEmpty) {
                      _showNoUserNameAlert();
                    } else {
                      createUser(userNameTextController.text, firebaseInstance);
                      //go to home screen
                      Navigator.of(context).pushReplacementNamed('/home');
                    }
                  }),
            )
          ],
        ));
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
