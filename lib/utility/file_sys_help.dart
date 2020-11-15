import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:software_engineering_project/utility/globals.dart';

class FileSystemHelper {

  Future<String> get getHomePath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<String> getDirPath(String dir) async {
    final path = await getHomePath;
    return '$path/$dir';
  }

  Future<String> getFilePath(String filename) async {
    final path = await getHomePath;
    return '$path/$filename';
  }

}