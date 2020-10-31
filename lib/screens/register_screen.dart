import 'package:flutter/material.dart';
import 'package:software_engineering_project/globals.dart';
import 'package:uuid/uuid.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var userNameTextController = TextEditingController(text: "testUsername"); //TODO: remove test username

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
                onPressed: (){
                  if(userNameTextController.text.isEmpty){ _showNoUserNameAlert();}
                  else _createUser();
                }
              ),
            )
          ],
        ));
  }

  void _createUser(){
    var uuidGen = Uuid();
    var uuid = uuidGen.v4();

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
