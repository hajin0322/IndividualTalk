import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final Function(String) onSendMessage;

  const CustomInputField({super.key, required this.onSendMessage});

  @override
  State<CustomInputField> createState() => _CustomInputField();
}

class _CustomInputField extends State<CustomInputField> {
  final TextEditingController _controller = TextEditingController();
  bool _isSendButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _isSendButtonEnabled = _controller.text.length >= 20;
    });
  }

  void _handleSend() {
    if (_isSendButtonEnabled) {
      final message = _controller.text;
      widget.onSendMessage(message);
      _controller.clear();
      setState(() {
        _isSendButtonEnabled = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
          Expanded(
              child: TextField(
            controller: _controller,
            maxLines: null,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Input message here",
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
              suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.emoji_emotions_outlined)),
            ),
          )),
          GestureDetector(
            onTap: _handleSend,
            child: Container(
                padding: const EdgeInsets.all(12.0),
                alignment: Alignment.center,
                color: _isSendButtonEnabled ? Colors.yellow : Colors.grey,
                child: const Icon(Icons.send)),
          )
        ],
      ),
    );
  }
}
