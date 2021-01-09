import 'package:software_engineering_project/utility/globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import '../utility/crypto.dart';
import '../utility/json_help.dart';

void saveMessageListToJson(User receiverData, List<Message> messagesFromJsonList, String messageFilePath) async {
  List<Map<String, dynamic>> messageList = List<Map<String, dynamic>>();
  var jsonHelp = JsonHelper();

  FirebaseFirestore.instance
      .collection("Users")
      .doc(globals.currentUser.uuID)
      .collection("messages")
      .doc("activeChats")
      .collection(receiverData.uuID)
      .orderBy("sentTime")
      .get()
      .then((firestoreMessages) {
    if (messagesFromJsonList != null) {
      messageList
          ?.addAll(messagesFromJsonList?.map((e) => e.toJson())?.toList());
    }
    messageList?.addAll(firestoreMessages?.docs?.map((e) => e?.data()));
    var messageListJson = jsonHelp.returnJsonString(messageList);
    jsonHelp.writeJsonStringToFile(messageFilePath, messageListJson);
    //deleting all messages in firestore
    firestoreMessages?.docs?.forEach((element) {
      element?.reference?.delete();
    });
  });
}

void sendMessage(String messageText, User receiverData, CollectionReference senderMessagesFS, CollectionReference receiverMessagesFS) async {
  if (messageText.isEmpty) return;

  print(receiverData.RSA_public_key);

  var encryptedText = encrypt(receiverData.RSA_public_key, messageText);

  var encryptedMessage = Message(globals.currentUser, receiverData.uuID,
      DateTime.now().millisecondsSinceEpoch.toString(), encryptedText);

  var message = Message(globals.currentUser, receiverData.uuID,
      DateTime.now().millisecondsSinceEpoch.toString(), messageText);
  //sending message to firestore
  senderMessagesFS?.add(message.toJson());
  receiverMessagesFS?.add(encryptedMessage.toJson());
}