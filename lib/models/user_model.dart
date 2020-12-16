class User {
  String userName;
  String uuID;
  String addedTime;
  String lastMessage = "";
  String lastMessageTime = "";
  String RSA_public_key = "";
  String RSA_private_key = "";

  User(
      String userName, String uuID, String addedTime, String privateKeyString) {
    this.userName = userName;
    this.uuID = uuID;
    this.addedTime = addedTime;
    this.RSA_private_key = privateKeyString;
  }

  User.fromJson(Map<String, dynamic> json) {
    this.userName = json["username"];
    this.uuID = json["UUID"];
    this.addedTime = json["addedTime"];
    this.RSA_public_key = json["RSA_public_key"];
  }

  Map<String, dynamic> toJson() => {
        'username': userName,
        'UUID': uuID,
        'addedTime': addedTime,
        'RSA_public_key': RSA_public_key
      };
}
