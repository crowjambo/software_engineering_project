import 'package:basic_utils/basic_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:software_engineering_project/utility/crypto.dart';

void main() {
  test("When given simple text Then returns encrypted string", () {
    var starterText = "Encrypt this";
    var keyPar = CryptoUtils.generateRSAKeyPair();
    var publicKeyString = CryptoUtils.encodeRSAPublicKeyToPem(keyPar.publicKey);

    var expectedText = CryptoUtils.rsaEncrypt(starterText, keyPar.publicKey);

    var encryptedText = encrypt(publicKeyString, starterText);
    expect(encryptedText, expectedText);
  });

  test("When given encrypted Then returns decrypted string", () {
    var starterText = "Encrypt this";
    var keyPar = CryptoUtils.generateRSAKeyPair();
    var privateKeyString = CryptoUtils.encodeRSAPrivateKeyToPem(keyPar.privateKey);

    var encryptedText = CryptoUtils.rsaEncrypt(starterText, keyPar.publicKey);

    var decryptedText = decrypt(privateKeyString, encryptedText);
    expect(decryptedText, starterText);
  });
}