import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileManager {
  static Future<double> get readTextFile async {
    var content = 1.0;
    try {
      final file = await _getFile;
      final text = await file.readAsString();
      content = double.parse(text);
    } catch (e) {
      print(e);
    }
    return content;
  }

  static Future<void> writeTextFile(String text) async {
    try {
      final file = await _getFile;
      await file.writeAsString(text);
    } catch (e) {
      print(e);
    }
  }

  static Future<File> get _getFile async {
    final path = await _getFilePath;
    return File('$path/text.txt');
  }

  static Future<String> get _getFilePath async {
    final directory = await getExternalStorageDirectory();
    return directory!.path;
  }
}
