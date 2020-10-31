import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text("blabla")),
      body: StreamBuilder(
          stream: Firestore.instance.collection("Superheros").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return new Text("Connecting");
            return new ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.documents[index];
                  //has json in it
                  return new Text(ds['name']);
                });
          }),
    );
  }
}
