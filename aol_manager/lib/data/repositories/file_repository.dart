import 'dart:convert';
import 'dart:io';
import 'package:aol_manager/data/models/message_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class FileRepository {
  // Default filename for the messages JSON
  static const String _defaultFilename = 'love_messages.json';

  /// Get the app's documents directory
  Future<Directory> _getAppDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  /// Get the default file path
  Future<File> _getDefaultFile() async {
    final directory = await _getAppDirectory();
    return File('${directory.path}/$_defaultFilename');
  }

  /// Load messages from default location
  Future<List<Message>> loadMessages() async {
    try {
      final file = await _getDefaultFile();
      if (!await file.exists()) {
        return [];
      }

      final contents = await file.readAsString();
      final jsonData = jsonDecode(contents) as List;
      return jsonData.map((item) => Message.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Error loading messages: $e');
    }
  }

  /// Save messages to default location
  Future<void> saveMessages(List<Message> messages) async {
    try {
      final file = await _getDefaultFile();
      final jsonData = messages.map((m) => m.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonData));
    } catch (e) {
      throw Exception('Error saving messages: $e');
    }
  }

  /// Import messages from a JSON file
  Future<List<Message>> importMessages() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null) throw Exception('No file selected');

      final file = File(result.files.single.path!);
      final contents = await file.readAsString();
      final jsonData = jsonDecode(contents) as List;
      return jsonData.map((item) => Message.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Error importing messages: $e');
    }
  }

  /// Export messages to a JSON file
  Future<void> exportMessages(List<Message> messages) async {
    try {
      final result = await FilePicker.platform.saveFile(
        fileName: 'love_messages.json',
      );

      if (result == null) throw Exception('No file location selected');

      final file = File(result);
      final sorted = [...messages]..sort((a, b) => a.date.compareTo(b.date));
      final jsonData = sorted.map((m) => m.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonData));
    } catch (e) {
      throw Exception('Error exporting messages: $e');
    }
  }
}
