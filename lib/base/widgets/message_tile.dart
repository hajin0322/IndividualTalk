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

  String _formatTime(String dateTime) {
    final time = DateTime.parse(dateTime);
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays >= 1) {
      // 하루 이상 차이가 날 경우, 일자로 표시
      return '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}';
    } else {
      // 하루가 지나지 않았을 경우, 시간으로 표시
      final hours = time.hour.toString().padLeft(2, '0');
      final minutes = time.minute.toString().padLeft(2, '0');
      return '$hours:$minutes';
    }
  }

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
          maxLines: 1,
          style: AppStyles.s1(context)?.copyWith(color: Colors.grey),
        ),
        trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatTime(lastDate.toString()),
                style: AppStyles.s1(context)?.copyWith(color: Colors.grey),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  // 빨간 원 배경
                  Container(
                    width: 18, // 원의 너비
                    height: 18, // 원의 높이
                    decoration: BoxDecoration(
                      color: (unreadNumber == 0)? Colors.grey:Colors.red, // 원의 배경색
                      shape: BoxShape.circle,
                    ),
                  ),
                  // 읽지 않은 메시지 수 텍스트
                  Text(
                    unreadNumber.toString(),
                    style: AppStyles.s1(context)?.copyWith(
                      color: Colors.white, // 텍스트 색상
                      fontSize: 12, // 텍스트 크기
                      fontWeight: FontWeight.bold, // 텍스트 굵기
                    ),
                  ),
                ],
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