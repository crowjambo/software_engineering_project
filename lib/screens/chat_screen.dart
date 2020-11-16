import 'package:flutter/material.dart';
import 'package:software_engineering_project/models/message_model.dart';
import 'package:software_engineering_project/models/user_model.dart';
import 'package:software_engineering_project/utility/file_sys_help.dart';
import 'package:software_engineering_project/utility/globals.dart';
import 'package:software_engineering_project/utility/json_help.dart';

class ChatScreen extends StatefulWidget {
  final User senderData;

  ChatScreen({this.senderData});

  @override
  _ChatScreenState createState() => _ChatScreenState(senderData);
}

class _ChatScreenState extends State<ChatScreen> {
  _ChatScreenState(this.senderData) {
    this.jsonHelp = JsonHelper();
    this.fileSysHelp = FileSystemHelper();
    this.messageFilePath = kChatDir + senderData.uuID + kMessageFile;
  }

  var jsonHelp;
  var fileSysHelp;
  User senderData;
  String messageFilePath;
  List<dynamic> messageList;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kThemeColor,
        appBar: AppBar(
          brightness: Brightness.dark,
          centerTitle: true,
          title: Text(senderData.userName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: kDefaultHeaderSize,
                fontWeight: FontWeight.bold,
              )),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: chatAreaFutureBuilder());
  }

  Widget _chatBubble(Message message, bool isMe, bool isSameUser) {
    if (isMe) {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          !isSameUser
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      message.sentTime,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundImage: AssetImage(
                            'assets/images/nick-fury.jpg'), //todo: probably remove this
                      ),
                    ),
                  ],
                )
              : Container(
                  child: null,
                ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          !isSameUser
              ? Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundImage: AssetImage(
                            'assets/images/nick-fury.jpg'), //todo: probably remove this
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      message.sentTime,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                )
              : Container(
                  child: null,
                ),
        ],
      );
    }
  }

  Widget _sendMessageArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: kAccentColor,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message..',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget chatAreaFutureBuilder() {
    return FutureBuilder<List<dynamic>>(
        future: jsonHelp.getJsonArray(this.messageFilePath),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            return chatArea(snapshot.data);
          } else if (snapshot.hasError) {
            return Center(
                child: Text("No Conversation Yet... (._.)\n${snapshot.error}"));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget chatArea(List<dynamic> messages) {
    if (messages.isEmpty) {
      return Column(
        children: <Widget>[
          Expanded(
            child: Container(
                color: Colors.white,
                child: Center(child: Text("No Conversation Yet..."))),
          ),
          _sendMessageArea(),
        ],
      );
    }else{
      return Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: EdgeInsets.all(20),
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final Message message = messages[index];
                final bool isMe = message.sender.id == currentUser.id;
                final bool isSameUser = prevUserId == message.sender.id;
                prevUserId = message.sender.id;
                return _chatBubble(message, isMe, isSameUser);
              },
            ),
          ),
          _sendMessageArea(),
        ],
      );
    }

  }
}
