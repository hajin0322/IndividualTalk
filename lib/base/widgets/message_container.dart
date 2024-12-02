import 'package:flutter/material.dart';

import '../res/media.dart';

class MessageContainer extends StatelessWidget {
  final bool isUserMessage;
  final void Function(BuildContext, int) showContextMenu;
  final void Function(int) stickOnTop;
  final Map<String, dynamic> message;
  final String agentName;
  final int index;

  const MessageContainer(
      {super.key,
      required this.isUserMessage,
      required this.agentName,
      required this.showContextMenu,
      required this.message,
      required this.index,
      required this.stickOnTop});

  @override
  Widget build(BuildContext context) {
    String formatTime(String dateTime) {
      final time = DateTime.parse(dateTime);
      final hours = time.hour.toString().padLeft(2, '0');
      final minutes = time.minute.toString().padLeft(2, '0');
      return '$hours:$minutes';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUserMessage) // AI 메시지일 때 프로필 표시
            Column(children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: const AssetImage(AppMedia.person),
                backgroundColor: Colors.grey[300],
              )
            ]),
          const SizedBox(
            width: 8,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: isUserMessage
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!isUserMessage)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      agentName,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: Colors.black),
                    ),
                  ),
                Row(
                  mainAxisAlignment: isUserMessage
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (isUserMessage)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          formatTime(message['time']),
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: Colors.grey),
                        ),
                      ),
                    Flexible(
                      child: GestureDetector(
                        onTap: () => showContextMenu(context, index),
                        onLongPress: () => stickOnTop(index),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isUserMessage
                                ? Colors.yellow.shade600
                                : Colors.white,
                            borderRadius: isUserMessage
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10))
                                : const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                          ),
                          child: Text(
                            message['content'],
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (!isUserMessage)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          formatTime(message['time']),
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: Colors.grey),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
