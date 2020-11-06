import 'package:flutter/material.dart';

class NewContactScreen extends StatefulWidget {
  NewContactScreen({Key key}) : super(key: key);

  @override
  _NewContactScreenState createState() => _NewContactScreenState();
}

class _NewContactScreenState extends State<NewContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new contact"),
        ),
        body: Column(
        children: <Widget>[ 
          Text("BOOOOOOOOOOOOOOOOOOOOOOOOOORF"),
        ]
        ),
    );
  }
}