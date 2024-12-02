import 'package:flutter/material.dart';
import 'package:individual_project/base/utils/chat_room_provider.dart';
import 'package:individual_project/base/utils/shared_preferences.dart';
import 'package:individual_project/base/widgets/message_container.dart';
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
  String? _stickyMessage;
  late ChatRoomProvider chatRoomProvider;

  @override
  void initState() {
    super.initState();
    _loadMessages();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
      chatRoomProvider = Provider.of<ChatRoomProvider>(context, listen: false);

      final chatRoom = chatRoomProvider.chatRooms.firstWhere(
        (room) => room['agentName'] == widget.agentName,
        orElse: () => {},
      );

      setState(() {
        _stickyMessage = chatRoom['stickyMessage'] ?? '';
      });

      _scrollToBottom();
      chatRoomProvider
          .updateChatRoomInfo(widget.agentName, {'unreadNumber': 0});
    });
  }

  Future<void> _loadMessages() async {
    _messages = await SharedPreferences.readChatRoom(widget.agentName);
    setState(() {});
  }

  Future<void> _saveMessages() async {
    await SharedPreferences.writeChatRoom(widget.agentName, _messages);
  }

  Future<void> _saveStickyMessage(String? message) async {
    chatRoomProvider
        .updateChatRoomInfo(widget.agentName, {'stickyMessage': message});
  }

  void _addMessage(String role, String content) {
    setState(() {
      _messages.add({
        'role': role,
        'content': content,
        'time': DateTime.now().toString(),
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

  void _deleteMessage(int index) {
    setState(() {
      final deletedMessage = _messages.removeAt(index);
      if (_stickyMessage == deletedMessage['content']) {
        _stickyMessage = '';
      }
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
      final message = _messages[index]['content'];
      _stickyMessage = message;
    });
    _saveStickyMessage(_stickyMessage);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  void _showContextMenu(BuildContext context, int index) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              ListTile(
                  title: const Text("Copy"),
                  onTap: () {
                    Navigator.of(context).pop();
                  }),
              ListTile(
                title: const Text("Share"),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text("Delete message"),
                onTap: () {
                  Navigator.of(context).pop();
                  _deleteMessage(index);
                },
              ),
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
      body: Stack(children: [
        Column(
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
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            child: MessageContainer(
                              message: message,
                              isUserMessage: isUserMessage,
                              agentName: widget.agentName,
                              showContextMenu: _showContextMenu,
                              stickOnTop: _stickMessageOnTop,
                              index: index,
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
        if (_stickyMessage != '') // 스티키 메시지 표시
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Icon(Icons.speaker_notes_rounded),
                ),
                Expanded(
                  child: Text(
                    _stickyMessage!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down_outlined),
                  onPressed: () {},
                )
              ],
            ),
          ),
      ]),
    );
  }
}
