import 'package:flutter/material.dart';
import 'package:individual_project/base/utils/file_helper.dart';

enum ChatRoomSortOption { name, date }

class ChatRoomProvider with ChangeNotifier {
  List<Map<String, dynamic>> chatRooms = [];

  ChatRoomProvider() {
    loadChatRooms();
  }

  Future<void> loadChatRooms() async {
    chatRooms = await FileHelper.readChatList();
    notifyListeners();
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
    chatRooms.add(newRoom);
    await FileHelper.writeChatList(chatRooms);
    await FileHelper.writeChatRoom(agentName, []);
    notifyListeners();
  }

  void stickOnTop(String agentName, ChatRoomSortOption sortOption) async {
    final index =
        chatRooms.indexWhere((room) => room["agentName"] == agentName);
    if (index != -1) {
      chatRooms[index]['isPinned'] = true;
      await FileHelper.writeChatList(chatRooms);
      sortChatRooms(sortOption: sortOption);
      notifyListeners();
    }
  }

  void sortChatRooms({required ChatRoomSortOption sortOption}) async {
    chatRooms.sort((a, b) {
      if (a['isPinned'] && !b['isPinned']) return -1;
      if (!a['isPinned'] && b['isPinned']) return 1;

      if (sortOption == ChatRoomSortOption.name) {
        return a['agentName'].compareTo(b['agentName']);
      } else if (sortOption == ChatRoomSortOption.date) {
        return DateTime.parse(b['lastDate'])
            .compareTo(DateTime.parse(a['lastDate']));
      }
      return 0;
    });
  }
}
