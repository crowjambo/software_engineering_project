import 'package:software_engineering_project/models/user_model.dart';
import 'package:software_engineering_project/utility/local_storage.dart';
import 'package:software_engineering_project/utility/globals.dart' as globals;

Future<bool> currentUserExists() async {
  bool userReg;
  await LocalStorage.init();
  print(LocalStorage.prefs.toString());
  userReg = LocalStorage.prefs.getBool("userRegistered") ?? false;
  globals.currentUser = User(
      LocalStorage.prefs.getString("currentUserName"),
      LocalStorage.prefs.getString("currentUUID"),
      "Time IDK",
      LocalStorage.prefs.getString("RSA_private_key"));
  return userReg;
}