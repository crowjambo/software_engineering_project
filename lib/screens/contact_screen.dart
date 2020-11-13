import 'package:flutter/material.dart';
import 'package:software_engineering_project/utility/globals.dart';
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
          future: jsonHelp.getJsonArray(kContactListJson),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              return buildContactList(snapshot.data);
            } else if (snapshot.hasError) {
              print("error");
              return CircularProgressIndicator();
            } else {
              return CircularProgressIndicator();
            }
          },
        ));
  }

  Widget buildContactList(List<dynamic> contactData) {

    return ListView.builder(
        padding: EdgeInsets.all(kDefaultPadding),
        itemCount: contactData.length,
        itemBuilder: (context, i) {
          return Card(
            elevation: 4,
            child: ListTile(
              title: Text(contactData[i]["username"],
              style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                //todo create new chat
                print("todo create new chat");
              },
            ),
          );


        });
  }
}
