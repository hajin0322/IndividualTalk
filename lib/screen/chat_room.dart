import 'package:flutter/material.dart';
import 'package:individual_project/base/res/media.dart';
import 'package:individual_project/base/utils/chat_room_provider.dart';
import 'package:individual_project/base/utils/file_helper.dart';
import 'package:provider/provider.dart';

import '../base/res/styles/app_styles.dart';
import '../base/utils/api_service.dart';
import '../base/widgets/chat_app_bar.dart';
import '../base/widgets/custom_input_field.dart';

class ChatRoom extends StatefulWidget {
  final String agentName;

  const ChatRoom({super.key, required this.agentName});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _messages = [];
  late ChatRoomProvider chatRoomProvider;

  @override
  void initState() {
    super.initState();
    _loadMessages();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
      chatRoomProvider = Provider.of<ChatRoomProvider>(context, listen: false);
      chatRoomProvider.updateChatRoomInfo(widget.agentName, {
        'unreadNumber': 0
      });
    });
  }

  Future<void> _loadMessages() async {
    _messages = await FileHelper.readChatRoom(widget.agentName);
    setState(() {});
  }

  Future<void> _saveMessages() async {
    await FileHelper.writeChatRoom(widget.agentName, _messages);
  }

  void _addMessage(String role, String content) {
    setState(() {
      _messages.add({
        'role': role,
        'content': content,
        'time': DateTime.now().toString()
      });
    });
    _saveMessages();
    _scrollToBottom();

    chatRoomProvider.updateChatRoomInfo(widget.agentName, {
      'lastMessage': content,
      'lastDate': DateTime.now().toString(),
      'allMessages': _messages.length,
      'unreadNumber': 0
    });
  }

  void _deleteMessage (int index) {
    setState(() {
      _messages.removeAt(index);
    });
    _saveMessages();
    String lastMessage = '';
    if (_messages.isNotEmpty) {
      lastMessage = _messages.last['content'];
    }
    chatRoomProvider.updateChatRoomInfo(widget.agentName, {
      'lastMessage': lastMessage,
      'lastDate': DateTime.now().toString(),
      'allMessages': _messages.length
    });
  }

  void _stickMessageOnTop(int index) {
    setState(() {
      final message = _messages.removeAt(index);
      _messages.insert(0, message);
    });
    _saveMessages();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  String _formatTime(String dateTime) {
    final time = DateTime.parse(dateTime);
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  void _showContextMenu(BuildContext context, int index) {
    showDialog(context: context, builder: (context) {
      return SimpleDialog(
        children: [
          const ListTile(title: Text("Copy"),),
          const ListTile(title: Text("Share"),),
          ListTile(title: const Text("Delete message"),
            onTap: () {
              Navigator.of(context).pop();
              _deleteMessage(index);
            },),
          ListTile(
            title: const Text("Stick the message on top"),
            onTap: () {
              Navigator.of(context).pop();
              _stickMessageOnTop(index);
            },
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(agentName: widget.agentName),
      body: Column(
        children: [
          Expanded(
              child: Container(
                  color: AppStyles.chatBackground,
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final isUserMessage = message['role'] == 'user';

                        return Dismissible(
                          key: ValueKey(message),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            _deleteMessage(index);
                          },
                          background: Container(
                            color: Colors.red,
                            padding: const EdgeInsets.only(left: 20),
                            alignment: Alignment.centerLeft,
                            child: const Icon(Icons.delete, color: Colors.white,),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: isUserMessage
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                if (!isUserMessage) // AI 메시지일 때 프로필 표시
                                  Column(children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage:
                                      const AssetImage(AppMedia.person),
                                      backgroundColor: Colors.grey[300],
                                    )
                                  ]),
                                const SizedBox(width: 8,),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: isUserMessage
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      if (!isUserMessage)
                                        Text(
                                          widget.agentName,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      Row(
                                        mainAxisAlignment: isUserMessage
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children: [
                                          if (isUserMessage)
                                            Text(
                                              _formatTime(message['time']),
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          Flexible(
                                            child: GestureDetector(
                                              onLongPress: () => _showContextMenu(context, index),
                                              child: Container(
                                                margin: const EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: isUserMessage
                                                      ? Colors.yellow[300]
                                                      : Colors.white,
                                                  borderRadius:
                                                  BorderRadius.circular(10),
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
                                            Text(
                                              _formatTime(message['time']),
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }))),
          CustomInputField(onSendMessage: (message) async {
            _addMessage('user', message);
            final response =
            await ApiService.sendMessageToAPI(message, widget.agentName);
            if (response != null) {
              _addMessage('assistant', response);
            }
          })
        ],
      ),
    );
  }
}
