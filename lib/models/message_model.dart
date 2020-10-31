import 'package:software_engineering_project/models/user_model.dart';
import 'package:software_engineering_project/data/user_data.dart';

class Message {
  final User sender;
  final String time; // Would usually be type DateTime or Firebase Timestamp in production apps
  final String text;
  final bool unread;

  Message({
    this.sender,
    this.time,
    this.text,
    this.unread,
  });
}
