import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../base/utils/chat_room_provider.dart';
import '../base/widgets/message_tile.dart';
import '../base/widgets/sticky_on_top.dart';

class SortDate extends StatelessWidget {
  const SortDate({super.key});

  @override
  Widget build(BuildContext context) {
    final chatRoomProvider = Provider.of<ChatRoomProvider>(context, listen: true);

    final chatRooms =
    List<Map<String, dynamic>>.from(chatRoomProvider.chatRooms);

    chatRooms.sort((a, b) {
      if (!a['isPinned'] && !b['isPinned']) {
        return DateTime.parse(b['lastDate'])
            .compareTo(DateTime.parse(a['lastDate']));
      }
      return 0;
    });
    print('date added');

    return ListView.builder(
        itemCount: chatRooms.length,
        itemBuilder: (context, index) {
          final chatRoom = chatRooms[index];
          return GestureDetector(
              onLongPress: () => showDialog(
                  context: context,
                  builder: (context) => StickyOnTop(
                    agentName: chatRoom['agentName'],
                  )),
              child: MessageTile(
                key: ValueKey(
                    chatRoom['agentName'] + chatRoom['isPinned'].toString()),
                agentName: chatRoom['agentName'],
                allMessages: chatRoom['allMessages'],
                lastMessage: chatRoom['lastMessage'],
                lastDate: DateTime.parse(chatRoom['lastDate']),
                unreadNumber: chatRoom['unreadNumber'],
                isPinned: chatRoom['isPinned'],
              )
          );
        });
  }
}