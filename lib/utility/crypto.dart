import 'package:basic_utils/basic_utils.dart';

String encrypt(String RSAPublicKey, String messageText){
  var receiverPublicKey = CryptoUtils.rsaPublicKeyFromPem(RSAPublicKey);
  var encryptedText = CryptoUtils.rsaEncrypt(messageText, receiverPublicKey);

  return encryptedText;
}

String decrypt(String RSAPrivateKey, String messageText){
  var userPrivateKey = CryptoUtils.rsaPrivateKeyFromPem(RSAPrivateKey);
  var decryptedMessage = CryptoUtils.rsaDecrypt(messageText, userPrivateKey);
  return decryptedMessage;
}