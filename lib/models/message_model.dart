import 'dart:convert';

import 'package:software_engineering_project/models/user_model.dart';

class Message {
  User sender;
  String toUUID;
  String sentTime;
  String text;

  Message(User sender, String toUUID, String sentTime, String text) {
    this.sender = sender;
    this.toUUID = toUUID;
    this.sentTime = sentTime;
    this.text = text;
  }

  Message.fromJson(Map<String, dynamic> json) {
    var userJson = jsonDecode(json["sender"]);
    print(userJson.toString());

    this.sender = User.fromJson(userJson);
    this.toUUID = json["toUUID"];
    this.sentTime = json["sentTime"];
    this.text = json["text"];
  }

  Map<String, dynamic> toJson() => {
        'sender': jsonEncode(sender.toJson()),
        'toUUID': toUUID,
        "sentTime": sentTime,
        "text": text
      };
}
