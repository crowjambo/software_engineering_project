import 'package:basic_utils/basic_utils.dart';
import 'package:software_engineering_project/models/message_model.dart';
import 'package:software_engineering_project/models/user_model.dart';
import 'package:software_engineering_project/utility/globals.dart' as globals;

String encrypt(User receiverData, String messageText){
  var receiverPublicKeyString = receiverData.RSA_public_key;
  var receiverPublicKey = CryptoUtils.rsaPublicKeyFromPem(receiverPublicKeyString);
  var encryptedText = CryptoUtils.rsaEncrypt(messageText, receiverPublicKey);

  return encryptedText;
}

String decrypt(String message){
  var userPrivateKeyString = globals.currentUser.RSA_private_key;
  var userPrivateKey =
  CryptoUtils.rsaPrivateKeyFromPem(userPrivateKeyString);
  var messageText = CryptoUtils.rsaDecrypt(message, userPrivateKey);
  return messageText;
}