import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class JsonHelper {
  List<dynamic> decodedJsonArray;
  final String placeholderJsonString = "{\"array\": []}";

  Future createJsonFile(String filename) async {
    //returns if file with given username already exists
    if (File(await _localFile(filename)).existsSync()) {
      return;
    } else {
      //creates the file
      File newJsonFile = File(await _localFile(filename));
      newJsonFile.createSync();
      newJsonFile.writeAsStringSync(placeholderJsonString);
    }
  }

  //redundant
  Future createJsonFileNoExistCheck(String filename) async {
    //creates the file
    var newFilename = await _localFile(filename);
    File newJsonFile = File(newFilename);
    await newJsonFile.create();
    newJsonFile.writeAsStringSync(placeholderJsonString);
  }

  Future<List<dynamic>> getJsonArray(String filename) async {
    File jsonFile = File(await _localFile(filename));
    String jsonString = jsonFile.readAsStringSync();

    decodedJsonArray = jsonDecode(jsonString)['array'];
    return decodedJsonArray;
  }

  String returnJsonString(var array) {
    Map<String, dynamic> placeholderMap = {'array': array};
    String jsonString = jsonEncode(placeholderMap);

    return jsonString;
  }

  void writeJsonStringToFile(String filename, String jsonString) async {
    final file = File(await _localFile(filename));
    file.writeAsStringSync(jsonString);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<String> _localFile(String filename) async {
    final path = await _localPath;
    print('$path/');
    print('$path/$filename');
    return '$path/$filename';
  }
}
