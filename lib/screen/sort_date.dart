import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../base/utils/chat_room_provider.dart';
import '../base/widgets/message_tile.dart';
import '../base/widgets/sticky_on_top.dart';

class SortDate extends StatefulWidget {
  const SortDate({super.key});

  @override
  State<SortDate> createState() => _SortDateState();
}

class _SortDateState extends State<SortDate> {
  @override
  void initState() {
    super.initState();
    final chatRoomProvider =
        Provider.of<ChatRoomProvider>(context, listen: false);
    chatRoomProvider.sortChatRooms(sortOption: ChatRoomSortOption.date);
  }

  @override
  Widget build(BuildContext context) {
    final chatRoomProvider = Provider.of<ChatRoomProvider>(context);

    final chatRooms = chatRoomProvider.chatRooms;

    return ListView.builder(
        itemCount: chatRooms.length,
        itemBuilder: (context, index) {
          final chatRoom = chatRooms[index];
          return GestureDetector(
            onLongPress: () => showDialog(
              context: context,
              builder: (context) => StickyOnTop(
                  agentName: chatRoom['agentName'],
                  sortOption: ChatRoomSortOption.date),
            ),
            child: MessageTile(
              key: ValueKey(chatRoom['agentName']),
              agentName: chatRoom['agentName'],
              allMessages: chatRoom['allMessages'],
              lastMessage: chatRoom['lastMessage'],
              lastDate: DateTime.parse(chatRoom['lastDate']),
              unreadNumber: chatRoom['unreadNumber'],
              isPinned: chatRoom['isPinned'],
            ),
          );
        });
  }
}
