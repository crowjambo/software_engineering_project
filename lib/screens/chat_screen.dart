import 'package:flutter/material.dart';
import 'package:software_engineering_project/models/message_model.dart';
import 'package:software_engineering_project/models/user_model.dart';
import 'package:software_engineering_project/utility/file_sys_help.dart';
import 'package:software_engineering_project/utility/globals.dart' as globals;
import 'package:software_engineering_project/utility/json_help.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final User senderData;

  ChatScreen({this.senderData});

  @override
  _ChatScreenState createState() => _ChatScreenState(senderData);
}

class _ChatScreenState extends State<ChatScreen> {
  _ChatScreenState(this.receiverData) {
    this.jsonHelp = JsonHelper();
    this.fileSysHelp = FileSystemHelper();
    this.messageFilePath =
        globals.kChatDir + receiverData.uuID + globals.kMessageFile;
  }

  User receiverData;

  Stream<QuerySnapshot> senderMessagesStream;
  CollectionReference receiverMessagesFS;
  CollectionReference senderMessagesFS;

  JsonHelper jsonHelp;
  FileSystemHelper fileSysHelp;

  String messageFilePath;

  List<Message> messagesFromJsonList;
  List<Message> sessionMessages;

  var listViewScrollController = ScrollController();

  void scrollChatList() {
    if (listViewScrollController.hasClients) {
      listViewScrollController.animateTo(
          listViewScrollController.position.maxScrollExtent + 50,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut);
    }
  }

  @override
  void initState() {
    this.senderMessagesStream = FirebaseFirestore.instance
        .collection("Users")
        .doc(globals.currentUser.uuID)
        .collection("messages")
        .doc("activeChats")
        .collection(receiverData.uuID).orderBy("sentTime")
        .snapshots();

    this.receiverMessagesFS = FirebaseFirestore.instance
        .collection("Users")
        .doc(receiverData.uuID)
        .collection("messages")
        .doc("activeChats")
        .collection(globals.currentUser.uuID);

    this.senderMessagesFS = FirebaseFirestore.instance
        .collection("Users")
        .doc(globals.currentUser.uuID)
        .collection("messages")
        .doc("activeChats")
        .collection(receiverData.uuID);

    jsonHelp.getJsonArray(this.messageFilePath).then((result) {
      //result is List<dynamic> so map that on List<Message>
      setState(() {
        messagesFromJsonList =
            result.map((data) => Message.fromJson(data)).toList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    scrollChatList();
    return Scaffold(
        backgroundColor: globals.kThemeColor,
        appBar: AppBar(
          brightness: Brightness.dark,
          centerTitle: true,
          title: Text(receiverData.userName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: globals.kDefaultHeaderSize,
                fontWeight: FontWeight.bold,
              )),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () {
                //todo: save all messages when exiting
                Navigator.pop(context);
              }),
        ),
        body: chatAreaStreamBuilder());
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
                      message.sentTime.toString(),
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
                    Text(
                      message.sentTime.toString(),
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
    var messageTextController = TextEditingController();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: globals.kAccentColor,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: messageTextController,
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
            onPressed: () {
              sendMessage(messageTextController.text);
              scrollChatList();
              messageTextController.clear();
            },
          ),
        ],
      ),
    );
  }

  //todo do this
  Widget chatAreaStreamBuilder() {
    return new StreamBuilder<QuerySnapshot>(
        stream: senderMessagesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return chatArea(snapshot.data);
        });
  }

  Widget chatArea(QuerySnapshot messagesFF) {
    List<Message> messages = List<Message>();
    messages.addAll(messagesFromJsonList);
    messages.addAll(
        messagesFF.docs.map((e) => Message.fromJson(e.data())).toList());
    print(messagesFF.docs.length);


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
    } else {
      return Column(
        children: <Widget>[
          Expanded(
              child: Container(
            color: Colors.white,
            child: ListView.builder(
              controller: listViewScrollController,
              shrinkWrap: true,
              padding: EdgeInsets.all(20),
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final Message message = messages[index];
                final bool isMe =
                    message.sender.uuID == globals.currentUser.uuID;
                //todo: wtf is same user
                // final bool isSameUser = prevUserId == message.sender.id;
                // prevUserId = message.sender.id;
                final bool isSameUser = true;
                return _chatBubble(message, isMe, isSameUser);
              },
            ),
          )),
          _sendMessageArea(),
        ],
      );
    }
  }

  void sendMessage(String messageText) async {
    if (messageText.isEmpty) return;
    var message = Message(globals.currentUser, receiverData.uuID,
        DateTime.now().millisecondsSinceEpoch.toString(), messageText);
    //this.messagesFromJsonList.add(message);

    //sending message to firestore
    senderMessagesFS.add(message.toJson());
    receiverMessagesFS.add(message.toJson());
  }

//todo:
// 1. load messages from local storage
// 2.messaging takes place thru firestore
// 3. update local storage when closing the widget

}
