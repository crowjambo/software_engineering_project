import 'dart:io';

import 'package:flutter/material.dart';
import 'package:software_engineering_project/controllers/contact_controller.dart';
import 'package:software_engineering_project/utility/globals.dart' as globals;
import 'package:software_engineering_project/utility/json_help.dart';

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


}
