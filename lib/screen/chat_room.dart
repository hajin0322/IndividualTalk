import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../base/res/styles/app_styles.dart';
import '../base/utils/api_service.dart';
import '../base/widgets/chat_app_bar.dart';
import '../base/widgets/custom_input_field.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesString = prefs.getString('messages');

    if (messagesString != null) {
      setState(() {
        _messages = List<Map<String, dynamic>>.from(jsonDecode(messagesString));
      });
    }
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesString = jsonEncode(_messages);
    await prefs.setString('messages', messagesString);
  }

  void _addMessage(String role, String content) {
    setState(() {
      _messages.add({'role': role, 'content': content});
    });
    _saveMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatAppBar(),
      body: Column(
        children: [
          Expanded(
              child: Container(
                color: AppStyles.chatBackground,
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return Align(
                      alignment: message['role'] == 'user'
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: message['role'] == 'user'
                                  ? Colors.white
                                  : Colors.yellow,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(message['content'],
                              style: const TextStyle(fontSize: 16))),
                    );
                  },
                ),
              )),
          CustomInputField(onSendMessage: (message) async {
            _addMessage('user', message);
            final response = await ApiService.sendMessageToAPI(message);
            if (response != null) {
              _addMessage('assistant', response);
            }
          })
        ],
      ),
    );
  }
}
