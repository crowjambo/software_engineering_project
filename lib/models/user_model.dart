class User {
  String userName;
  String uuID;
  String addedTime;
  String lastMessage = "";
  String lastMessageTime = "";

  User({
    this.userName,
    this.uuID,
    this.addedTime,
  });

  User.fromJson(Map<String,dynamic> json){
    this.userName = json["username"];
    this.uuID = json["UUID"];
    this.addedTime = json["addedTime"];
  }

  Map<String, dynamic> toJson() =>
      {
        'username': userName,
        'UUID': uuID,
        'addedTime': addedTime
      };

}