import 'package:flutter/material.dart';

import 'file_helper.dart';

class ChatRoomProvider with ChangeNotifier {
  List<Map<String, dynamic>> chatRooms = [];

  ChatRoomProvider() {
    loadChatRooms();
  }

  Future<void> loadChatRooms() async {
    notifyListeners();
    chatRooms = await FileHelper.readChatList();
  }

  void addNewChatRoom(String agentName) async {
    final newRoom = {
      "agentName": agentName,
      "allMessages": 0,
      "lastMessage": "",
      "lastDate": DateTime.now().toString(),
      "unreadNumber": 0,
      "isPinned": false
    };
    chatRooms = [...chatRooms, newRoom];
    notifyListeners();
    await FileHelper.writeChatList(chatRooms);
    await FileHelper.writeChatRoom(agentName, []);
  }

  void stickOnTop(String agentName) async {
    final index =
        chatRooms.indexWhere((room) => room["agentName"] == agentName);
    if (index != -1) {
      final pinnedRoom = chatRooms.removeAt(index);
      pinnedRoom['isPinned'] = true;
      chatRooms.insert(0, pinnedRoom);
      notifyListeners();
      await FileHelper.writeChatList(chatRooms);
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
      await FileHelper.writeChatList(chatRooms);
    }
  }
}