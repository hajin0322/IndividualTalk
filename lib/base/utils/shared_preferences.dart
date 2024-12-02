import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/*
[chatlog.json = List<Map<String, dynamic>>]
String -> agentName, allMessages, lastMessage, lastDate, unreadNumber
dynamic -> each type of instances

[log_$agentName.json = List<Map<String, dynamic>]
String -> agentName, String ->
*/

class SharedPreferences {
  static Future<File> _getLocalFile(String filename) async {
    final directory = await getDownloadsDirectory();
    if (directory == null) {
      throw Exception("Failed to get the downloads directory.");
    }
    await directory.create(recursive: true);
    File file = File('${directory.path}/$filename');
    if (!(await file.exists())) {
      await file.writeAsString(jsonEncode([]));
    }
    return file;
  }

  // ChatList 읽기
  static Future<List<Map<String, dynamic>>> readChatList() async {
    try {
      final file = await _getLocalFile('chatlog.json');
      final contents = await file.readAsString();
      return List<Map<String, dynamic>>.from(jsonDecode(contents));
    } catch (e) {
      print("Error reading chat list: $e");
    }
    return [];
  }

  // ChatList 쓰기
  static Future<void> writeChatList(
      List<Map<String, dynamic>> chatRooms) async {
    final file = await _getLocalFile('chatlog.json');
    await file.writeAsString(jsonEncode(chatRooms));
  }

  // ChatRoom 읽기
  static Future<List<Map<String, dynamic>>> readChatRoom(
      String agentName) async {
    try {
      final file = await _getLocalFile('log_$agentName.json');
      if (await file.exists()) {
        final contents = await file.readAsString();
        return List<Map<String, dynamic>>.from(jsonDecode(contents));
      }
    } catch (e) {
      print("Error reading chat room: $e");
    }
    return [];
  }

  // ChatRoom 쓰기
  static Future<void> writeChatRoom(
      String agentName, List<Map<String, dynamic>> messages) async {
    final file = await _getLocalFile('log_$agentName.json');
    await file.writeAsString(jsonEncode(messages));
  }
}
