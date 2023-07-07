import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A class that provides file services.
class FileService {
  // Filepath from application directory with filename and extension
  String filePath;

  FileService(this.filePath);

  /// Returns the path to the application directory.
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Returns the JSON file.
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$filePath');
  }

  /// Writes the given JSON map to the JSON file.
  Future<void> writeJson(Map<String, dynamic> json) async {
    // final file = await _localFile;
    // return file.writeAsString('$json');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(filePath, jsonEncode(json));
  }

  /// Reads the JSON file and returns a map.
  Future<Map<String, dynamic>> readJson() async {
    // try {
    //   final file = await _localFile;

    //   final contents = json.decode(await file.readAsString());

    //   return Map<String, dynamic>.from(contents);
    // } catch (e) {
    //   return {};
    // }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Map<String, dynamic>.from(prefs.get(filePath) as dynamic);
  }
}
