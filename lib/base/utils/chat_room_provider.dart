import 'package:flutter/material.dart';

import 'shared_preferences.dart';

class ChatRoomProvider with ChangeNotifier {
  List<Map<String, dynamic>> chatRooms = [];

  ChatRoomProvider() {
    loadChatRooms();
  }

  Future<void> loadChatRooms() async {
    notifyListeners();
    chatRooms = await SharedPreferences.readChatList();
  }

  void addNewChatRoom(String agentName) async {
    final newRoom = {
      "agentName": agentName,
      "allMessages": 0,
      "lastMessage": "",
      "lastDate": DateTime.now().toString(),
      "unreadNumber": 0,
      "isPinned": false,
      "stickyMessage": ''
    };
    chatRooms = [...chatRooms, newRoom];
    notifyListeners();
    await SharedPreferences.writeChatList(chatRooms);
    await SharedPreferences.writeChatRoom(agentName, []);
  }

  void stickOnTop(String agentName) async {
    final index =
        chatRooms.indexWhere((room) => room["agentName"] == agentName);
    if (index != -1) {
      final pinnedRoom = chatRooms.removeAt(index);
      pinnedRoom['isPinned'] = true;
      chatRooms.insert(0, pinnedRoom);
      notifyListeners();
      await SharedPreferences.writeChatList(chatRooms);
    }
  }

  void updateChatRoomInfo(String agentName, Map<String, dynamic> info) async {
    final index = chatRooms.indexWhere((room) => room['agentName'] == agentName);
    if (index != -1) {
      final updatedRoom = {...chatRooms[index], ...info};
      chatRooms = [
        ...chatRooms.sublist(0, index),
        updatedRoom,
        ...chatRooms.sublist(index + 1)
      ];
      print("updateChatRoomInfo $chatRooms");
      notifyListeners();
      await SharedPreferences.writeChatList(chatRooms);
    }
  }
}