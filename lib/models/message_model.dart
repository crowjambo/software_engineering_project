import 'dart:convert';

import 'package:software_engineering_project/models/user_model.dart';

class Message {
  User sender;
  String toUUID;
  String sentTime; // Would usually be type DateTime or Firebase Timestamp in production apps
  String text;

  Message({
    this.sender,
    this.toUUID,
    this.sentTime,
    this.text,
  });

  Message.fromJson(Map<String, dynamic> json){
    this.sender = json["sender"];
    this.toUUID= json["toUUID"];
    this.sentTime=json["sentTime"];
    this.text= json["text"];
  }

  Map<String, dynamic> toJson() =>
      {
        'sender': jsonEncode(sender.toJson()),
        'toUUID': toUUID,
        "sentTime": sentTime,
        "text": text
      };

}
