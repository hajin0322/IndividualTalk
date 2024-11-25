import 'package:flutter/material.dart';
import '../../screen/chat_room.dart';
import '../res/media.dart';
import '../res/styles/app_styles.dart';

class MessageTile extends StatelessWidget {
  final String agentName;
  final int allMessages;
  final String lastMessage;
  final DateTime lastDate;
  final int unreadNumber;
  final bool isPinned;

  const MessageTile(
      {super.key,
      required this.agentName,
      required this.allMessages,
      required this.lastMessage,
      required this.lastDate,
      required this.unreadNumber,
      this.isPinned = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Image.asset(AppMedia.person,
            width: 40, height: 40, fit: BoxFit.cover),
        title: Row(
          children: [
            Text(
              agentName,
              style: AppStyles.t1,
            ),
            isPinned
                ? const Icon(Icons.push_pin, size: 16)
                : Text(
                    allMessages.toString(),
                    style: AppStyles.s1(context)?.copyWith(color: Colors.grey),
                  )
          ],
        ),
        subtitle: Text(
          lastMessage,
          style: AppStyles.s1(context)?.copyWith(color: Colors.grey),
        ),
        trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                lastDate.toString(),
                style: AppStyles.s1(context)?.copyWith(color: Colors.grey),
              ),
              Text(
                unreadNumber.toString(),
                style: AppStyles.s1(context)?.copyWith(color: Colors.grey),
              )
            ]),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatRoom(agentName: agentName)));
        });
  }
}