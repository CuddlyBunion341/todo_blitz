import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class FileService {
  // Filepath from application directory with filename and extension
  String filePath;

  FileService(this.filePath);

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$filePath');
  }

  Future<File> writeJson(Map<String, dynamic> json) async {
    final file = await _localFile;

    return file.writeAsString('$json');
  }

  Future<Map<String, dynamic>> readJson() async {
    try {
      final file = await _localFile;

      final contents = json.decode(await file.readAsString());

      return Map<String, dynamic>.from(contents);
    } catch (e) {
      return {};
    }
  }
}
